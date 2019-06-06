require_relative '20160815161420_rolify_create_roles'

class DropRolify < ActiveRecord::Migration[5.2]
  def change
    revert RolifyCreateRoles
  end
end
