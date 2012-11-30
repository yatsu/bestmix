ActiveAdmin.register Doorkeeper::AccessGrant do
  index do
    column :owner do |grant|
      div User.find_by_id(grant.resource_owner_id).email
    end
    column :application
    column :token do |grant|
      div truncate(grant.token)
    end
    column :expires_in
    column :redirect_uri
    column :revoked_at
    # column :scopes
    default_actions
  end
end
