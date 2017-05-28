ActiveAdmin.register User do
  menu priority: 2

  index do
    column :email
    column :created_at
    column :updated_at
    actions
  end

  config.sort_order = 'email_asc'

  filter :email
  filter :roles
end
