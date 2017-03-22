class VideoSerializer < ActiveModel::Serializer
  attributes :id, :api_id, :title, :thumbnail, :duration, :published_at
end
