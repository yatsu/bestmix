ActiveAdmin.register Post do
  index do
    column :id, sotrable: true
    column :title do |post|
      div(:style => "white-space: nowrap") do
        truncate(post.title)
      end
    end
    column :content do |post|
      div truncate(post.content)
    end
    column :published_at, sortable: true
    default_actions
  end
end
