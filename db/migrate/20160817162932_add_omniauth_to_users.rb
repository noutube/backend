class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, default: '', null: false
    add_column :users, :uid, :string, default: '', null: false
    add_index :users, [ :provider, :uid ]
  end
end
