class MyPostsController < InheritedResources::Base
  defaults :resource_class => Post, :collection_name => 'posts', :instance_name => 'post'

  before_filter :authenticate_user!

  def create
    create! { my_posts_path }
    @post.user = current_user
    @post.save
  end

  def update
    update! { my_posts_path }
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def collection
    @posts ||= end_of_association_chain.order("updated_at DESC")
    # @posts ||= end_of_association_chain.page((params[:page] || 1).to_i)
  end
end
