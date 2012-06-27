class PostsController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    redirect_to root_path
  end

  def create
    create! { root_path }
    @post.user = current_user
    @post.save
  end
end
