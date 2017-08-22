# == Schema Information
#
# Table name: items
#
#  id              :binary(16)       not null, primary key
#  subscription_id :binary(16)       not null
#  video_id        :binary(16)       not null
#  state           :integer          default("state_new"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_items_on_subscription_id  (subscription_id)
#  index_items_on_video_id         (video_id)
#  sqlite_autoindex_items_1        (id) UNIQUE
#

class Item < ApplicationRecord
  include ActiveUUID::UUID
  natural_key :created_at, :subscription_id, :video_id

  enum state: [:state_new, :state_later]
  STATE_LABELS = ['New', 'Later'].freeze

  belongs_to :subscription
  belongs_to :video
  # convenience
  has_one :channel, through: :video
  has_one :user, through: :subscription
end
