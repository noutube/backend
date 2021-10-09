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
    Channel.where('(SELECT COUNT(*) FROM subscriptions WHERE subscriptions.channel_id = channels.id) = 0').destroy_all
    Item.joins(:video).where('items.state = 0 AND videos.published_at < ?', 7.days.ago).destroy_all
    Video.where('(SELECT COUNT(*) FROM items WHERE items.video_id = videos.id) = 0 AND videos.published_at < ?', 1.day.ago).destroy_all
    puts "culled #{channel_count - Channel.count} channels (#{subscription_count - Subscription.count} subscriptions)"
    puts "culled #{video_count - Video.count} videos (#{item_count - Item.count} items)"

    # get thumbnail if missing
    Channel.where(thumbnail: '').find_each do |channel|
      channel.scrape
      channel.save
    end

    # get duration if missing
    Video.where(duration: 0).find_each do |video|
      video.scrape
      if video.expired_live_content?
        video.destroy
      else
        video.save
      end
    end
  end
end
