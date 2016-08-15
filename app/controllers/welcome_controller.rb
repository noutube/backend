require 'google/apis/youtube_v3'

class WelcomeController < ApplicationController
  def index
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = nil
    youtube.key = ENV["GOOGLE_API_KEY"]

    @channels = [{ id: 'UCAWQEAjn8udSFKN6D4NlqWQ' }, { id: 'UCFKDEp9si4RmHFWJW1vYsMA' }, { id: 'UC3tNpTOHsTnkmbwztCs30sA' }]
    @videos = []

    # get channel data, updated infrequently
    youtube.batch do |youtube|
      @channels.each do |channel|
        youtube.list_channels('snippet,contentDetails', id: channel[:id]) do |result|
          item = result.items.first
          channel[:title] = item.snippet.title
          channel[:thumbnail] = item.snippet.thumbnails.default.url
          channel[:uploads] = item.content_details.related_playlists.uploads
          channel[:checked] = DateTime.now - 4.days # XXX arbitrary initial limit on videos to fetch
        end
      end
    end

    # get new videos
    @channels.each do |channel|
      result = youtube.list_playlist_items('snippet', playlist_id: channel[:uploads], max_results: 2)
      while true
        added = 0
        result.items.each do |item|
          break if item.snippet.published_at.to_datetime < channel[:checked]
          @videos << {
            id: item.snippet.resource_id.video_id,
            channel: channel[:id],
            published_at: item.snippet.published_at.to_datetime,
            title: item.snippet.title,
            thumbnail: item.snippet.thumbnails.default.url
          }
          added += 1
        end

        # hit the end
        break if added < 2 || result.next_page_token.nil?

        # get next page
        result = youtube.list_playlist_items 'snippet',
          playlist_id: channel[:uploads],
          max_results: 2,
          page_token: result.next_page_token
      end
    end

    # get duration for each video
    youtube.batch do |youtube|
      @videos.each do |video|
        youtube.list_videos('snippet,contentDetails', id: video[:id]) do |result|
          item = result.items.first
          captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?(\d+)S/).captures
          video[:duration] = (captures[1].nil? ? 0 : captures[1].to_i.hours) + (captures[3].nil? ? 0 : captures[3].to_i.minutes) + captures[4].to_i.seconds
        end
      end
    end

    # done
    render json: {
      channels: @channels,
      videos: @videos
    }
  end
end
