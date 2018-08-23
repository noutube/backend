ActiveAdmin.register Subscription do
  menu parent: 'Channels'

  permit_params :user_id, :channel_id

  controller do
    def scoped_collection
      super.includes :user, :channel
    end
  end

  index do
    column :user, sortable: 'users.email'
    column :channel, sortable: 'channels.title'
    column :created_at
    column :updated_at
    actions
  end

  filter :user_email, as: :string
  filter :channel_title, as: :string
end
