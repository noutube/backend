# == Schema Information
#
# Table name: channels
#
#  id         :uuid(16)         not null, primary key
#  api_id     :string           not null
#  title      :string           not null
#  thumbnail  :string           not null
#  uploads_id :string           default(""), not null
#  checked_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  secret_key :string           default(""), not null
#
# Indexes
#
#  index_channels_on_api_id     (api_id)
#  sqlite_autoindex_channels_1  (id) UNIQUE
#

require 'securerandom'
require 'net/http'

class Channel < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  include ActiveUUID::UUID
  natural_key :created_at, :api_id

  has_many :videos, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
  # convenience
  has_many :items, through: :subscriptions

  validates :api_id, presence: true
  validates :title, presence: true
  validates :thumbnail, presence: true

  before_create :generate_secret_key

  def generate_secret_key
    self.secret_key = SecureRandom.hex
  end

  after_create :subscribe

  before_destroy do
    subscribe('unsubscribe')
  end

  def subscribe(mode = 'subscribe')
    Net::HTTP.post_form \
      URI('https://pubsubhubbub.appspot.com/subscribe'),
      'hub.callback' => push_callback_url(api_id),
      'hub.topic' => "https://www.youtube.com/xml/feeds/videos.xml?channel_id=#{api_id}",
      'hub.mode' => mode,
      'hub.secret' => secret_key,
      'hub.verify' => 'async'
  end
end
