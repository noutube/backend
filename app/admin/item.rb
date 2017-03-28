ActiveAdmin.register Item do
  menu parent: 'Videos'

  permit_params :state

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
    column :state do |item|
      Item::STATE_LABELS[Item.states[item.state]]
    end
    actions
  end

  filter :state, as: :select, collection: Item::STATE_LABELS.zip(Item.states.values)
  filter :video_title, as: :string
  filter :user_email, as: :string
  filter :channel_title, as: :string

  form do |f|
    semantic_errors
    inputs 'Details' do
      input :state, as: :select, collection: Item::STATE_LABELS.zip(Item.states.keys), include_blank: false
    end
    actions
  end
end
