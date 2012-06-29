object false

node(:current_page) { @posts.current_page }
node(:total_count) { @posts.total_count }
node(:num_pages) { @posts.num_pages }

child @posts do
  extends "api/v1/posts/show"
end
