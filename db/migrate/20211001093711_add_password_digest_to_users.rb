class AddPasswordDigestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :password_digest, :string
    User.find_each do |user|
      user.update(password: 'password')
    end
    change_column_null :users, :password_digest, false
  end
end
