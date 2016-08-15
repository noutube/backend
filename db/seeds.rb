# default admin
Role.find_or_create_by(name: 'admin')

# some sample data to play around with
if Rails.env.development?
  User.find_or_create_by(email: 'admin@dbk.cloudapp.net') do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.add_role :admin
  end
end
