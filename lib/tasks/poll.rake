require 'google/apis/youtube_v3'
require 'modules/auth'

namespace :nou2ube do
  desc 'Poll for new videos'
  task poll: :environment do
    # force sync output under systemd
    $stdout.sync = true

    puts "getting subscriptions for #{User.count} users..."
    channel_count = Channel.count
    subscription_count = Subscription.count
    User.all.each do |user|
      # create client
      client = Auth.build_client \
        access_token: user.access_token,
        refresh_token: user.refresh_token,
        expires_at: user.expires_at
      if user.expires_at.nil? || client.expires_within?(1.day)
        client.refresh!
        user.update! \
          access_token: client.access_token,
          refresh_token: client.refresh_token,
          expires_at: client.expires_at
      end

      # create authorized service
      youtube = Google::Apis::YoutubeV3::YouTubeService.new
      youtube.authorization = client

      # get subscriptions
      items = youtube.fetch_all do |token|
        youtube.list_subscriptions('snippet', mine: true, max_results: 50, page_token: token)
      end
      items.each do |item|
        # exclude gigantic topic channels
        next if item.snippet.title.end_with?(' - Topic')

        channel = Channel.find_or_initialize_by(api_id: item.snippet.resource_id.channel_id)
        channel.title = item.snippet.title
        channel.thumbnail = item.snippet.thumbnails.default.url
        channel.checked_at = DateTime.current if channel.new_record?
        channel.save

        Subscription.find_or_create_by(user: user, channel: channel)
      end
      # remove subscriptions which no longer exist
      Subscription.joins(:channel, :user)
                  .where('users.id = ? AND channels.api_id NOT IN (?)', user.id,
                         items.map { |item| item.snippet.resource_id.channel_id })
                  .destroy_all
    rescue Exception => e
      puts "Failed to authorize #{user.email}: #{e}"
    end
    puts "added #{Channel.count - channel_count} channels (#{Subscription.count - subscription_count} subscriptions)"

    # create anonymous service
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = ENV['GOOGLE_API_KEY']

    # get uploads_id if missing
    channels = Channel.where(uploads_id: '')
    if channels.count.positive?
      puts "filling uploads_id for #{channels.count} channels..."
      channels_count = 0
      channels.each do |channel|
        youtube.list_channels('snippet,contentDetails', id: channel.api_id) do |result, err|
          channels_count += 1
          puts "#{channels_count}..." if channels_count % 50 == 0

          next if err

          item = result.items.first
          channel.uploads_id = item.content_details.related_playlists.uploads
          channel.save
        end
      end
    end

    # get new videos
    puts "getting new videos for #{Channel.count} channels..."
    video_count = Video.count
    item_count = Item.count
    to_check = Channel.all.to_a.clone
    to_check_token = {}
    to_check_latest = {}
    to_check_count = 0
    while to_check.count.positive?
      to_check.each do |channel|
        youtube.list_playlist_items('snippet', playlist_id: channel.uploads_id, max_results: 1, page_token: to_check_token[channel.api_id]) do |result, err|
          to_check_count += 1
          puts "#{to_check_count}..." if to_check_count % 50 == 0

          if err
            to_check.delete channel
            next
          end
          to_check_token[channel.api_id] = result.next_page_token
          to_check_latest[channel.api_id] = channel.checked_at if to_check_latest[channel.api_id].nil?

          stop = false
          result.items.each do |item|
            published_at = item.snippet.published_at.to_datetime
            unless published_at > channel.checked_at
              stop = true
              break
            end

            to_check_latest[channel.api_id] = published_at if published_at > to_check_latest[channel.api_id]

            Video.find_or_create_by(api_id: item.snippet.resource_id.video_id) do |video|
              video.channel = channel
              video.published_at = published_at
              video.title = item.snippet.title
              video.thumbnail = item.snippet.thumbnails.medium.url
            end
          end

          stop = true unless result.next_page_token

          if stop
            to_check.delete channel
            channel.checked_at = to_check_latest[channel.api_id]
            channel.save
          end
        end
      end
    end
    puts "added #{Video.count - video_count} videos (#{Item.count - item_count} items)"

    # get duration if missing
    videos = Video.where(duration: 0)
    if videos.count.positive?
      puts "filling duration for #{videos.count} videos..."
      videos_count = 0
      videos.each do |video|
        youtube.list_videos('snippet,contentDetails', id: video.api_id) do |result, err|
          videos_count += 1
          puts "#{videos_count}..." if videos_count % 50 == 0

          next if err

          item = result.items.first

          if item.snippet.live_broadcast_content == 'none' && item.snippet.thumbnails.to_h.values.pluck(:url).none? { |url| url.include?('_live') }
            captures = item.content_details.duration.match(/PT((\d+)H)?((\d+)M)?((\d+)S)?/).captures
            video.duration = (captures[0].nil? ? 0 : captures[1].to_i.hours) +
                             (captures[2].nil? ? 0 : captures[3].to_i.minutes) +
                             (captures[4].nil? ? 0 : captures[5].to_i.seconds)
            video.save
          else
            # destroy if livestream
            video.destroy
          end
        end
      end
    end

    # cull leftover records
    puts 'culling leftover records...'
    channel_count = Channel.count
    subscription_count = Subscription.count
    video_count = Video.count
    item_count = Item.count
    Channel.where('(SELECT COUNT(*) FROM subscriptions WHERE subscriptions.channel_id = channels.id) = 0').destroy_all
    Item.joins(:video).where('items.state = 0 AND videos.published_at < ?', 7.days.ago).destroy_all
    Video.where('(SELECT COUNT(*) FROM items WHERE items.video_id = videos.id) = 0 AND videos.published_at < ?', 1.day.ago).destroy_all
    puts "culled #{channel_count - Channel.count} channels (#{subscription_count - Subscription.count} subscriptions)"
    puts "culled #{video_count - Video.count} videos (#{item_count - Item.count} items)"
  end
end
