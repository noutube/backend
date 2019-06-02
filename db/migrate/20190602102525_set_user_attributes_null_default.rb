class SetUserAttributesNullDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :email, from: '', to: nil
    change_column_null :users, :authentication_token, false
    change_column_null :users, :refresh_token, false
  end
end
