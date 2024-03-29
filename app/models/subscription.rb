# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  channel_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_channel_id              (channel_id)
#  index_subscriptions_on_id                      (id) UNIQUE
#  index_subscriptions_on_user_id                 (user_id)
#  index_subscriptions_on_user_id_and_channel_id  (user_id,channel_id) UNIQUE
#

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  after_create :broadcast_push
  after_destroy do
    if channel.items.where(user: user).exists?
      broadcast_push
    else
      # if the user has no videos for this channel,
      # pretend the channel no longer exists
      broadcast_destroy
    end
  end

  def broadcast_push
    channel.broadcast_push(user)
  end

  def broadcast_destroy
    channel.broadcast_destroy(user)
  end
end
