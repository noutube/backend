namespace :nou2ube do
  desc 'Poll for new videos'
  task poll: :environment do
    # force sync output under systemd
    $stdout.sync = true

    # TODO get new videos
    # puts "getting new videos for #{Channel.count} channels..."
    # video_count = Video.count
    # item_count = Item.count
    # to_check = Channel.all.to_a.clone
    # while to_check.count.positive?
    #   to_check.each do |channel|
    #     # TODO
    #   end
    # end
    # puts "added #{Video.count - video_count} videos (#{Item.count - item_count} items)"

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
      video.save
    end
  end
end
