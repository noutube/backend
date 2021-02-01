class RemoveRedundantColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :channels, :uploads_id, :string, default: '', null: false
    remove_column :users, :access_token, :string
    remove_column :users, :expires_at, :datetime
    remove_column :users, :refresh_token, :string, null: false
    remove_column :videos, :thumbnail, :string, null: false
  end
end
