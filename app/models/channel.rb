# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  api_id     :string           not null
#  title      :string           not null
#  thumbnail  :string           default(""), not null
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
require 'modules/scrape'
require 'net/http'

class Channel < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :videos, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  # convenience
  has_many :users, through: :subscriptions
  has_many :items, through: :videos
  has_many :video_users, through: :items, source: :user

  validates :api_id, presence: true
  validates :title, presence: true

  before_create do
    self.secret_key = SecureRandom.hex
  end

  after_create :subscribe

  after_update do
    all_users.each do |user|
      broadcast_push(user)
    end
  end

  before_destroy do
    subscribe('unsubscribe')
  end

  def all_users
    (users + video_users).uniq
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

  def scrape(body = nil)
    return unless body = Scrape.scrape('channel', channelId: api_id) unless body

    self.thumbnail = body['thumbnail']
    self.title = body['title']
  end

  def broadcast_push(user)
    payload = ActiveModelSerializers::SerializableResource.new \
      self,
      scope: user
    FeedChannel.broadcast_to \
      user,
      action: :push,
      payload: payload
  end
end
