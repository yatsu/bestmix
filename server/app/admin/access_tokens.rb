ActiveAdmin.register Doorkeeper::AccessToken do
  index do
    column :owner do |grant|
      div User.find_by_id(grant.resource_owner_id).email
    end
    column :application
    column :token do |grant|
      div truncate(grant.token)
    end
    column :refresh_token do |grant|
      div truncate(grant.refresh_token)
    end
    column :expires_in
    column :revoked_at
    # column :scopes
    default_actions
  end
end
