# == Schema Information
#
# Table name: roles
#
#  id            :binary(16)       not null, primary key
#  name          :string
#  resource_id   :binary(16)
#  resource_type :string
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_roles_on_name                                    (name)
#  index_roles_on_name_and_resource_type_and_resource_id  (name,resource_type,resource_id)
#  sqlite_autoindex_roles_1                               (id) UNIQUE
#

class Role < ApplicationRecord
  include ActiveUUID::UUID
  natural_key :created_at

  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource, polymorphic: true, required: false

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  scopify
end
