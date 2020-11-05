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

    video.fetch_duration
    video.save

    head :ok
  end
end
