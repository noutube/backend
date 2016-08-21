require 'google/apis/youtube_v3'

class WelcomeController < ApplicationController
  acts_as_token_authentication_handler_for User

  def index
    authorization = Signet::OAuth2::Client.new(
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://www.googleapis.com/oauth2/v3/token',
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      refresh_token: current_user.refresh_token
    )
    authorization.refresh!
    current_user.refresh_token = authorization.refresh_token
    current_user.save

    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.authorization = authorization

    @channels = []
    @videos = []

    # get subscriptions
    youtube.fetch_all do |token|
      youtube.list_subscriptions('snippet', mine: true, max_results: 50, page_token: token)
    end.each do |item|
      @channels << {
        id: item.snippet.resource_id.channel_id,
        title: item.snippet.title,
        thumbnail: item.snippet.thumbnails.default.url,
        checked: DateTime.now - 1.day
      }
    end

    # get channel data, updated infrequently
    youtube.batch do |youtube|
      @channels.each do |channel|
        youtube.list_channels('snippet,contentDetails', id: channel[:id]) do |result, err|
          item = result.items.first
          channel[:title] = item.snippet.title
          channel[:thumbnail] = item.snippet.thumbnails.default.url
          channel[:uploads] = item.content_details.related_playlists.uploads
        end
      end
    end

    # get new videos
    @to_check = @channels.clone
    @to_check_token = {}
    while @to_check.count > 0 do
      youtube.batch do |youtube|
        @to_check.each do |channel|
          youtube.list_playlist_items('snippet', playlist_id: channel[:uploads], max_results: 2, page_token: @to_check_token[channel[:id]]) do |result, err|
            @to_check_token[channel[:id]] = result.next_page_token
            added = false
            result.items.each do |item|
              break if item.snippet.published_at.to_datetime < channel[:checked]
              added = true
              @videos << {
                id: item.snippet.resource_id.video_id,
                channel: channel[:id],
                published_at: item.snippet.published_at.to_datetime,
                title: item.snippet.title,
                thumbnail: item.snippet.thumbnails.default.url
              }
            end
            @to_check.delete channel unless added
          end
        end
      end
    end

    # get duration for each video
    youtube.batch do |youtube|
      @videos.each do |video|
        youtube.list_videos('contentDetails', id: video[:id]) do |result, err|
          item = result.items.first
          captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?((\d+)S)?/).captures
          video[:duration] = (captures[1].nil? ? 0 : captures[2].to_i.hours) + (captures[3].nil? ? 0 : captures[4].to_i.minutes) + (captures[5].nil? ? 0 : captures[6].to_i.seconds)
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
