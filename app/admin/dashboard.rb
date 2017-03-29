ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1

  content title: 'Dashboard' do
    para "#{User.count} users, #{Channel.count} channels (#{Subscription.count} subscriptions), #{Video.count} videos (#{Item.count} items)"
  end
end
