class ItemSerializer < ActiveModel::Serializer
  attributes :id, :subscription_id, :state

  belongs_to :video
end
