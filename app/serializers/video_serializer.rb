class VideoSerializer < ActiveModel::Serializer
  attributes :id, :api_id, :title, :thumbnail, :duration, :published_at, :is_live, :is_live_content, :is_upcoming, :scheduled_at

  attribute :state do
    Item.find_by(video: object, user: scope).state
  end

  attribute :progress do
    Item.find_by(video: object, user: scope).progress
  end

  attribute :tags do
    Item.find_by(video: object, user: scope).tags
  end

  belongs_to :channel
end
