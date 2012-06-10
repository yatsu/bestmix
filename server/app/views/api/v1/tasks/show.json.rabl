object @task

attributes :id, :name, :public

node(:created_at) { |t| t.created_at.iso8601 }
node(:updated_at) { |t| t.updated_at.iso8601 }

child :user do
  extends "api/v1/users/show"
end
