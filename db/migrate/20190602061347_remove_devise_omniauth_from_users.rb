class RemoveDeviseOmniauthFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, [:provider, :uid]
    remove_column :users, :provider, :string, default: '', null: false
    remove_column :users, :uid, :string, default: '', null: false
  end
end
