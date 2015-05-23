require 'google/api_client'

class WelcomeController < ApplicationController
  def index
    # setup
    client = Google::APIClient.new(application_name: 'nou2ube', application_version: '0.1.0')
    youtube = client.discovered_api('youtube', 'v3')

    # auth
    client.authorization = nil
    key = ENV["GOOGLE_API_KEY"]

    @channels = [{ id: 'UCAWQEAjn8udSFKN6D4NlqWQ' }, { id: 'UCFKDEp9si4RmHFWJW1vYsMA' }, { id: 'UC3tNpTOHsTnkmbwztCs30sA' }]
    @videos = []

    @channels.each do |channel|
      # get channel data, updated infrequently
      result = client.execute(
        api_method: youtube.channels.list,
        parameters: {
          key: key,
          id: channel[:id],
          part: 'snippet,contentDetails'
        },
      )
      channel[:title] = result.data.items[0].snippet.title
      channel[:thumbnail] = result.data.items[0].snippet.thumbnails.default.url
      channel[:uploads] = result.data.items[0].contentDetails.relatedPlaylists.uploads
      channel[:checked] = DateTime.now - 4.days

      # check for new items
      result = client.execute(
        api_method: youtube.playlist_items.list,
        parameters: {
          key: key,
          playlistId: channel[:uploads],
          part: 'snippet',
          maxResults: 2
        },
      )
      while true
        added = 0
        result.data.items.each do |item|
          break if item.snippet.publishedAt.to_datetime < channel[:checked]
          @videos << {
            id: item.snippet.resourceId.videoId,
            channel: channel[:id],
            publishedAt: item.snippet.publishedAt.to_datetime,
            title: item.snippet.title,
            thumbnail: item.snippet.thumbnails.default.url
          }
          added += 1
        end

        # hit the end
        break if added < 2 || result.data.nextPageToken.nil?

        # get next page
        result = client.execute(
          api_method: youtube.playlist_items.list,
          parameters: {
            key: key,
            playlistId: channel[:uploads],
            part: 'snippet',
            maxResults: 2,
            pageToken: result.data.nextPageToken
          },
        )
      end
    end

    # get durations
    i = 0
    limit = 50
    while i < @videos.length
      result = client.execute(
        api_method: youtube.videos.list,
        parameters: {
          key: key,
          id: @videos[i...i+limit].map{ |video| video[:id] }.join(','),
          part: 'contentDetails',
          maxResults: [@videos.length - i, limit].min
        },
      )
      result.data.items.each do |item|
        captures = item.contentDetails.duration.match(/PT((\d+)H)?((\d+)M)?(\d+)S/).captures
        @videos[i][:duration] = (captures[1].nil? ? 0 : captures[1].to_i.hours) + (captures[3].nil? ? 0 : captures[3].to_i.minutes) + captures[4].to_i.seconds
        i += 1
      end
    end

    # done
    render 'results'
  end
end
