object @post

attributes :id, :title, :content

node(:created_at) { |t| t.created_at.iso8601 }
node(:updated_at) { |t| t.updated_at.iso8601 }
node(:published_at) { |t| t.published_at ? t.published_at.iso8601 : nil }

child :user do
  extends "api/v1/users/show"
end
