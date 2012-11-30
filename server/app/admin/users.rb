ActiveAdmin.register User do
  index do
    column :id, sotrable: true
    column :email
    column :current_sign_in_at
    column :current_sign_in_ip
    default_actions
  end
end
