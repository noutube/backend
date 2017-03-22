class ItemSerializer < ActiveModel::Serializer
  attributes :id, :state

  belongs_to :subscription
  belongs_to :video
end
