class VideoSerializer < ActiveModel::Serializer
  attributes :id, :api_id, :title, :thumbnail, :duration, :published_at, :is_live, :is_live_content, :is_upcoming, :scheduled_at, :visibility

  attribute :state do
    Item.find_by(video: object, user: scope).state
  end

  attribute :progress do
    Item.find_by(video: object, user: scope).progress
  end

  belongs_to :channel
end
