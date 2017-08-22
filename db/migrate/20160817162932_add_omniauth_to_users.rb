class AddOmniauthToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :provider, :string, default: '', null: false
    add_column :users, :uid, :string, default: '', null: false
    add_index :users, [:provider, :uid], unique: true
  end
end
