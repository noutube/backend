namespace :noutube do
  desc 'Poll for new videos'
  task poll: :environment do
    # force sync output under systemd
    $stdout.sync = true

    # cull leftover records
    puts 'culling leftover records...'
    channel_count = Channel.count
    subscription_count = Subscription.count
    video_count = Video.count
    item_count = Item.count

    # soft delete any new videos older than a week
    Item.joins(:video).where("items.state = 'new' AND videos.published_at < ?", 7.days.ago).find_each do |item|
      item.update!(state: :deleted)
    rescue StandardError => error
      puts "failed to update item #{item.id}: #{error.message}"
    end

    # hard delete any videos soft deleted for a week
    Item.where("items.state = 'deleted' AND items.updated_at < ?", 7.days.ago).find_each do |item|
      item.destroy!

      # if this was the last video this user had for this channel,
      # and the user is not subscribed to the channel,
      # pretend the channel no longer exists
      unless item.channel.items.where(user: item.user).exists? || Subscription.where(channel: item.channel, user: item.user).exists?
        item.channel.broadcast_destroy(item.user)
      end
    rescue StandardError => error
      puts "failed to destroy item #{item.id}: #{error.message}"
    end

    # delete any videos without items, but keep for one day
    # to help reduce spurious recreations by PushController updates
    Video.where('(SELECT COUNT(*) FROM items WHERE items.video_id = videos.id) = 0 AND videos.published_at < ?', 1.day.ago).destroy_all

    # delete any channels without any subscriptions or videos
    Channel.where('(SELECT COUNT(*) FROM subscriptions WHERE subscriptions.channel_id = channels.id) = 0 AND (SELECT COUNT(*) FROM videos WHERE videos.channel_id = channels.id) = 0').destroy_all

    puts "culled #{channel_count - Channel.count} channels (#{subscription_count - Subscription.count} subscriptions)"
    puts "culled #{video_count - Video.count} videos (#{item_count - Item.count} items)"

    # get thumbnail if missing
    puts "scraping #{Channel.where(thumbnail: '', visibility: :visible).count} videos..."
    Channel.where(thumbnail: '', visibility: :visible)
      .find_each do |channel|
        channel.scrape
        channel.save
      end

    # get duration if missing
    puts "scraping #{Video.where(duration: 0, visibility: :visible).count} videos..."
    scraped = 0
    not_scraped = 0
    Video.where(duration: 0, visibility: :visible)
      .find_each do |video|
        video.scrape
        unless video.changed?
          not_scraped += 1
          next
        end
        scraped += 1
        if video.expired_live_content?
          video.destroy
        else
          video.save
        end
      end
    puts "  #{scraped} scraped, #{not_scraped} not scraped"
  end
end
