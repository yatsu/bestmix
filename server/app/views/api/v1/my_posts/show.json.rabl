object @post

attributes :id, :title, :content

node(:created_at) { |p| p.created_at.iso8601 }
node(:updated_at) { |p| p.updated_at.iso8601 }
node(:published_at) { |p| p.published_at ? p.published_at.iso8601 : nil }

child :user do
  attributes :id, :email

  node :facebook_user, :if => lambda { |u| u.uid } do |u|
    { :id => u.uid }
  end
end
