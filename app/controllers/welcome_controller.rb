require 'google/apis/youtube_v3'

class WelcomeController < ApplicationController
  def index
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = nil
    youtube.key = ENV["GOOGLE_API_KEY"]

    @channels = [{ id: 'UCAWQEAjn8udSFKN6D4NlqWQ' }, { id: 'UCFKDEp9si4RmHFWJW1vYsMA' }, { id: 'UC3tNpTOHsTnkmbwztCs30sA' }]
    @videos = []

    @channels.each do |channel|
      # get channel data, updated infrequently
      result = youtube.list_channels 'snippet,contentDetails',
        id: channel[:id]
      channel[:title] = result.items[0].snippet.title
      channel[:thumbnail] = result.items[0].snippet.thumbnails.default.url
      channel[:uploads] = result.items[0].content_details.related_playlists.uploads
      channel[:checked] = DateTime.now - 4.days

      # check for new items
      result = youtube.list_playlist_items 'snippet',
        playlist_id: channel[:uploads],
        max_results: 2
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

    # get durations
    i = 0
    limit = 50
    while i < @videos.length
      result = youtube.list_videos 'contentDetails',
        id: @videos[i...i+limit].map{ |video| video[:id] }.join(','),
        max_results: [@videos.length - i, limit].min
      result.items.each do |item|
        captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?(\d+)S/).captures
        @videos[i][:duration] = (captures[1].nil? ? 0 : captures[1].to_i.hours) + (captures[3].nil? ? 0 : captures[3].to_i.minutes) + captures[4].to_i.seconds
        i += 1
      end
    end

    # done
    render json: {
      channels: @channels,
      videos: @videos
    }
  end
end
