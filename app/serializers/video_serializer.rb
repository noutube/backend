class VideoSerializer < ActiveModel::Serializer
  attributes :id, :api_id, :title, :thumbnail, :duration, :published_at, :is_live, :is_live_content, :is_upcoming, :scheduled_at

  belongs_to :channel
end
