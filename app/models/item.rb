# == Schema Information
#
# Table name: items
#
#  id              :integer          not null, primary key
#  subscription_id :integer          not null
#  video_id        :integer          not null
#  state           :integer          default("state_new"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_items_on_id               (id) UNIQUE
#  index_items_on_subscription_id  (subscription_id)
#  index_items_on_video_id         (video_id)
#

class Item < ApplicationRecord
  enum state: [:state_new, :state_later]
  STATE_LABELS = ['New', 'Later'].freeze

  belongs_to :subscription
  belongs_to :video
  # convenience
  has_one :channel, through: :video
  has_one :user, through: :subscription

  after_create :broadcast_create
  after_update :broadcast_update
  before_destroy :broadcast_destroy

  private

  def broadcast_create
    FeedChannel.broadcast_to(user,
                             action: :create,
                             payload: ActiveModelSerializers::SerializableResource.new(self, include: [:video]))
  end

  def broadcast_update
    FeedChannel.broadcast_to(user,
                             action: :update,
                             payload: ActiveModelSerializers::SerializableResource.new(self))
  end

  def broadcast_destroy
    FeedChannel.broadcast_to(user,
                             action: :destroy,
                             type: self.class.to_s.underscore,
                             id: id)
  end
end
