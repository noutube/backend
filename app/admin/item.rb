ActiveAdmin.register Item do
  menu parent: 'Videos'

  controller do
    def scoped_collection
      super.includes :video, subscription: [ :user, :channel ]
    end
  end

  index do
    column :video, sortable: 'video.title'
    column :subscription do |item| link_to 'Subscription', admin_subscription_path(item.subscription) end
    column :user, sortable: 'user.email'
    column :channel, sortable: 'channel.title'
    actions
  end

  filter :video_title, as: :string
  filter :user_email, as: :string
  filter :channel_title, as: :string
end
