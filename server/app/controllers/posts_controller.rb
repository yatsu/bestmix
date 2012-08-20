class PostsController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    redirect_to root_path
  end
end
