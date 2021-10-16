# == Schema Information
#
# Table name: users
#
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string           not null
#  id              :uuid             not null, primary key
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_id     (id) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  has_many :subscriptions, dependent: :destroy
  has_many :channels, through: :subscriptions
  # convenience
  has_many :items, through: :subscriptions
  has_many :videos, through: :subscriptions

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be an email address' }

  validates :password,
            length: { minimum: 8 }
end
