# == Schema Information
#
# Table name: channels
#
#  id         :uuid(16)         not null, primary key
#  api_id     :string           not null
#  title      :string           not null
#  thumbnail  :string           not null
#  uploads_id :string           not null
#  checked_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_channels_on_api_id     (api_id)
#  sqlite_autoindex_channels_1  (id) UNIQUE
#

class Channel < ActiveRecord::Base
  include ActiveUUID::UUID
  natural_key :created_at

  has_many :videos, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
  # convenience
  has_many :items, through: :subscriptions

  validates :api_id, presence: true
  validates :title, presence: true
  validates :thumbnail, presence: true
  validates :uploads_id, presence: true
end
