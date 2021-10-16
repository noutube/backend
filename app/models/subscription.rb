# == Schema Information
#
# Table name: subscriptions
#
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  id         :uuid             not null, primary key
#  channel_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_channel_id              (channel_id)
#  index_subscriptions_on_id                      (id) UNIQUE
#  index_subscriptions_on_user_id                 (user_id)
#  index_subscriptions_on_user_id_and_channel_id  (user_id,channel_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (user_id => users.id)
#

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_many :items, dependent: :destroy
  # convenience
  has_many :videos, through: :items

  after_create :broadcast_create
  before_destroy :broadcast_destroy

  def broadcast_create
    FeedChannel.broadcast_to(user,
                             action: :create,
                             payload: ActiveModelSerializers::SerializableResource.new(self, include: [:channel]))
  end

  def broadcast_update
    FeedChannel.broadcast_to(user,
                             action: :update,
                             payload: ActiveModelSerializers::SerializableResource.new(self, include: [:channel]))
  end

  def broadcast_destroy
    FeedChannel.broadcast_to(user,
                             action: :destroy,
                             type: self.class.to_s.underscore,
                             id: id)
  end
end
