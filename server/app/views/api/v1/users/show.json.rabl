object @user

attributes :id, :email, :created_at

# child :facebook_user, :if => lambda { |u| u.facebook_user } do
#   attributes :id, :name, :first_name, :last_name, :username, :gender
# end

node :facebook_user, :if => lambda { |u| u.facebook_user } do |u|
  {
  	:id => u.facebook_user.id,
  	:name => u.facebook_user.name,
    :first_name => u.facebook_user.first_name,
    :last_name => u.facebook_user.last_name,
    :username => u.facebook_user.username,
    :gender => u.facebook_user.gender
  }
end
