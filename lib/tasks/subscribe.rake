namespace :noutube do
  desc 'Subscribe for push notifications'
  task subscribe: :environment do
    # force sync output under systemd
    $stdout.sync = true

    # subscribe for push notifications to supplement polling
    puts "refreshing push notification subscription for #{Channel.count} channels..."
    Channel.all.each(&:subscribe)
  end
end
