# == Schema Information
#
# Table name: subscriptions
#
#  id         :uuid(16)         not null, primary key
#  user_id    :uuid(16)         not null
#  channel_id :uuid(16)         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_channel_id  (channel_id)
#  index_subscriptions_on_user_id     (user_id)
#  sqlite_autoindex_subscriptions_1   (id) UNIQUE
#

class Subscription < ActiveRecord::Base
  include ActiveUUID::UUID
  natural_key :created_at

  belongs_to :user
  belongs_to :channel
  has_many :items, dependent: :destroy
  # convenience
  has_many :videos, through: :items

  # TODO add cached counts of new and later items
  # probably add scoped associations, with cached counts each?
end
