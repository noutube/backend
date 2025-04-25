class PushController < ApplicationController
  def validate
    render plain: params['hub.challenge'].chomp
  end

  def callback
    channel = Channel.find_by(api_id: params[:channel_id])
    body = request.body.read

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), channel.secret_key, body)
    if request.headers['X-Hub-Signature'] != "sha1=#{signature}"
      head :ok
      return
    end

    entry = Hash.from_xml(body)['feed']['entry']

    unless entry
      # probably a delete, ignore
      head :ok
      return
    end

    video = Video.find_or_initialize_by(api_id: entry['videoId']) do |new_video|
      new_video.channel = channel
    end
    video.published_at = entry['published']
    video.title = entry['title']

    if video.new_record? && video.published_at < 1.day.ago
      # ignore, just someone updating an ancient video, don't re-create
      head :ok
      return
    end

    # scraping is slow, so only do it if we really have to
    video.scrape unless video.duration
    video.save unless video.expired_live_content?

    if video.previously_new_record?
      video.channel.users.find_each do |user|
        Item.find_or_create_by(user: user, video: video)
      end
    end

    # very often scraping fails right after a video is created, so defer and try again
    ScrapeVideoJob.set(wait: 10.seconds).perform_later(video) unless video.duration

    head :ok
  end
end
