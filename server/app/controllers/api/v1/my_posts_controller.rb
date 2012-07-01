class Api::V1::MyPostsController < Api::ApiController
  doorkeeper_for :all

  def index
    @posts = current_user.posts.order("updated_at DESC").page((params[:page] || 1).to_i)
    expires_in 5.seconds
    # fresh_when @posts.first
    fresh_when last_modified: @posts.maximum(:updated_at)
  end

  def show
    @post = current_user.posts.find_by_id(params[:id])
    if @post.nil?
      render_error(
        :resource_not_found,
        "Not Found",
        "Requested post does not exist or you don't have permission to see it."
      )
      return
    end
    expires_in 5.seconds
    fresh_when @post
  end

  def create
    @post = current_user.posts.create(params[:post])
    unless @post.valid?
      render_error(:invalid_parameter, "Parameter Error", @post.errors.messages)
      return
    end
    render :action => :show
  end

  def update
    @post = current_user.posts.find_by_id(params[:id])
    @post.update_attributes(params[:post])
    unless @post.valid?
      render_error(:invalid_parameter, "Parameter Error", @post.errors.messages)
      return
    end
    render :action => :show
  end
end
