# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  video_id   :integer          not null
#  state      :enum             default("new"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_items_on_id                    (id) UNIQUE
#  index_items_on_user_id               (user_id)
#  index_items_on_user_id_and_video_id  (user_id,video_id) UNIQUE
#  index_items_on_video_id              (video_id)
#

class Item < ApplicationRecord
  include PGEnum(state: [:new, :later], _prefix: true)

  belongs_to :user
  belongs_to :video
  # convenience
  has_one :channel, through: :video

  after_create :broadcast_push
  after_update :broadcast_push
  before_destroy :broadcast_destroy

  validate_enum_attribute :state

  def broadcast_push
    video.broadcast_push(user)
  end

  def broadcast_destroy
    video.broadcast_destroy(user)
  end
end
