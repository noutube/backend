namespace :nou2ube do
  desc 'Subscribe for push notifications'
  task subscribe: :environment do
    # subscribe for push notifications to supplement polling
    puts "refreshing push notification subscription for #{Channel.count} channels..."
    Channel.all.each(&:subscribe)
  end
end
