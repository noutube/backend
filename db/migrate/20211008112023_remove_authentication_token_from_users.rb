class RemoveAuthenticationTokenFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :authentication_token, :string, null: false
  end
end
