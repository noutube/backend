# == Schema Information
#
# Table name: users
#
#  id                   :uuid(16)         not null, primary key
#  email                :string           default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  authentication_token :string
#  provider             :string           default(""), not null
#  uid                  :string           default(""), not null
#  access_token         :string
#  refresh_token        :string
#  expires_at           :datetime
#
# Indexes
#
#  index_users_on_email             (email) UNIQUE
#  index_users_on_provider_and_uid  (provider,uid)
#  sqlite_autoindex_users_1         (id) UNIQUE
#

class User < ActiveRecord::Base
  include ActiveUUID::UUID
  natural_key :created_at

  rolify

  has_many :subscriptions, dependent: :destroy
  has_many :channels, through: :subscriptions
  # convenience
  has_many :items, through: :subscriptions
  has_many :videos, through: :subscriptions

  validates :email, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :uid, presence: true

  acts_as_token_authenticatable

  devise :omniauthable, omniauth_providers: [ :google_oauth2 ]

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
    user.update_authorization(auth.credentials)
    user.save
    user
  end

  def update_authorization(credentials)
    self.access_token = credentials.token
    self.refresh_token = credentials.refresh_token
    self.expires_at = Time.at(credentials.expires_at)
  end
end
