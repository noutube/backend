# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  api_id     :string           not null
#  title      :string           not null
#  thumbnail  :string           default(""), not null
#  checked_at :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  secret_key :string           default(""), not null
#
# Indexes
#
#  index_channels_on_api_id  (api_id) UNIQUE
#  index_channels_on_id      (id) UNIQUE
#

require 'securerandom'
require 'net/http'

class Channel < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :videos, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions
  # convenience
  has_many :items, through: :subscriptions

  validates :api_id, presence: true
  validates :title, presence: true

  before_create :generate_secret_key

  def generate_secret_key
    self.secret_key = SecureRandom.hex
  end

  after_create :subscribe

  after_update do
    subscriptions.each(&:broadcast_update)
  end

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

  def fetch_thumbnail
    return unless thumbnail.blank?
    response = Net::HTTP.get_response(URI("https://scrape.noutu.be/thumbnail?token=#{ENV['SCRAPE_TOKEN']}&channelId=#{api_id}"))
    return unless response.code == '200'
    body = JSON.parse(response.body)
    self.thumbnail = body['thumbnail']
  end
end
