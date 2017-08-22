class RolifyCreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table(:roles, id: false) do |t|
      t.integer :id, primary_key: true, null: false

      t.string :name
      t.integer :resource_id
      t.string :resource_type

      t.timestamps
    end

    create_table(:users_roles, id: false) do |t|
      t.integer :user_id
      t.integer :role_id
    end

    add_index :roles, :id, unique: true
    add_index :roles, :name, unique: true
    add_index :roles, [:name, :resource_type, :resource_id]
    add_index :users_roles, [:user_id, :role_id], unique: true
  end
end
