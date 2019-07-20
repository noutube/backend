require 'google/apis/youtube_v3'

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

    video = Video.find_or_initialize_by(api_id: entry['videoId']) do |video|
      video.channel = channel
    end
    video.published_at = entry['published']
    video.title = entry['title']

    if video.published_at < 1.hour.ago
      # ignore, just someone updating an ancient video
    elsif video.new_record?
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      youtube.key = ENV['GOOGLE_API_KEY']
      youtube.list_videos('snippet,contentDetails', id: video.api_id) do |result, _err|
        item = result.items.first

        # ignore if livestream
        if item.snippet.live_broadcast_content == 'none'
          captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?((\d+)S)?/).captures
          video.duration = (captures[0].nil? ? 0 : captures[1].to_i.hours) +
                           (captures[2].nil? ? 0 : captures[3].to_i.minutes) +
                           (captures[4].nil? ? 0 : captures[5].to_i.seconds)
          video.thumbnail = item.snippet.thumbnails.medium.url
          video.save
        end
      end
    else
      # just an update
      video.save
    end

    head :ok
  end
end
