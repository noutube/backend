ActiveAdmin.register Subscription do
  menu parent: 'Channels'

  permit_params :user_id, :channel_id

  controller do
    def scoped_collection
      super.includes :user, :channel
    end
  end

  index do
    column :user, sortable: 'user.email'
    column :channel, sortable: 'channel.title'
    actions
  end

  filter :user_email, as: :string
  filter :channel_title, as: :string
end
