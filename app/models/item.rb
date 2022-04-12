# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  video_id   :integer          not null
#  state      :integer          default("state_new"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_items_on_id        (id) UNIQUE
#  index_items_on_user_id   (user_id)
#  index_items_on_video_id  (video_id)
#

class Item < ApplicationRecord
  enum state: [:state_new, :state_later]

  belongs_to :user
  belongs_to :video
  # convenience
  has_one :channel, through: :video

  after_create :broadcast_create
  after_update :broadcast_update
  before_destroy :broadcast_destroy

  validate_enum_attribute :state

  def broadcast_create
    FeedChannel.broadcast_to(user,
                             action: :create,
                             payload: ActiveModelSerializers::SerializableResource.new(video, scope: user))
  end

  def broadcast_update
    FeedChannel.broadcast_to(user,
                             action: :update,
                             payload: ActiveModelSerializers::SerializableResource.new(video, scope: user))
  end

  def broadcast_destroy
    FeedChannel.broadcast_to(user,
                             action: :destroy,
                             type: :video,
                             id: video.id)
  end
end
