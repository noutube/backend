# == Schema Information
#
# Table name: subscriptions
#
#  id         :binary(16)       not null, primary key
#  user_id    :binary(16)       not null
#  channel_id :binary(16)       not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_channel_id              (channel_id)
#  index_subscriptions_on_user_id                 (user_id)
#  index_subscriptions_on_user_id_and_channel_id  (user_id,channel_id)
#  sqlite_autoindex_subscriptions_1               (id) UNIQUE
#

class Subscription < ApplicationRecord
  include ActiveUUID::UUID
  natural_key :created_at, :user_id, :channel_id

  belongs_to :user
  belongs_to :channel
  has_many :items, dependent: :destroy
  # convenience
  has_many :videos, through: :items

  def display_name
    "#{user.email} - #{channel.title}"
  end

  after_create :broadcast_create
  before_destroy :broadcast_destroy

  private

  def broadcast_create
    FeedChannel.broadcast_to(user,
                             action: :create,
                             payload: ActiveModelSerializers::SerializableResource.new(self, include: [:channel]))
  end

  def broadcast_destroy
    FeedChannel.broadcast_to(user,
                             action: :destroy,
                             type: self.class.to_s.underscore,
                             id: self.id)
  end
end
