object false

node(:current_page) { @tasks.current_page }
node(:total_count) { @tasks.total_count }
node(:num_pages) { @tasks.num_pages }

child @tasks do
  extends "api/v1/tasks/show"
end
