class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :api_id, :title, :thumbnail

  attribute :is_subscribed do
    Subscription.where(channel: object, user: scope).exists?
  end
end
