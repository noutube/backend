require 'google/apis/youtube_v3'

class PushController < ApplicationController
  protect_from_forgery except: :callback

  def validate
    render text: params['hub.challenge'].chomp, status: 200
  end

  def callback
    channel = Channel.find_by(api_id: params[:channel_id])
    body = request.body.read

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), channel.secret_key, body)
    if "sha1=#{signature}" != request.headers['X-Hub-Signature']
      render nothing: true, status: 200
      return
    end

    entry = Hash.from_xml(body)['feed']['entry']
    video = Video.find_or_initialize_by(api_id: entry['videoId']) do |video|
      video.channel = channel
      video.published_at = entry['published']
      video.title = entry['title']
    end

    if video.new_record?
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      youtube.key = ENV['GOOGLE_API_KEY']
      youtube.list_videos('snippet,contentDetails', id: video.api_id) do |result, err|
        item = result.items.first
        captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?((\d+)S)?/).captures
        video.duration = (captures[0].nil? ? 0 : captures[1].to_i.hours) +
                         (captures[2].nil? ? 0 : captures[3].to_i.minutes) +
                         (captures[4].nil? ? 0 : captures[5].to_i.seconds)
        video.thumbnail = item.snippet.thumbnails.medium.url
        video.save
      end
    else
      # just an update
      video.save
    end

    render nothing: true, status: 200
  end
end
