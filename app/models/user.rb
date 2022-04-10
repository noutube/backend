# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string           not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_id     (id) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  has_many :subscriptions, dependent: :destroy
  has_many :items, dependent: :destroy
  # convenience
  has_many :channels, through: :subscriptions
  has_many :videos, through: :items
  has_many :video_channels, through: :videos, source: :channel

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be an email address' }

  validates :password,
            length: { minimum: 8 }

  def all_channels
    (channels + video_channels).uniq
  end
end
