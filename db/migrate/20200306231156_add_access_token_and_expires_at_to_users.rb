class AddAccessTokenAndExpiresAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_token, :string
    add_column :users, :expires_at, :datetime
  end
end
