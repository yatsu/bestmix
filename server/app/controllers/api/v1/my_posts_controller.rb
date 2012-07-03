class Api::V1::MyPostsController < Api::ApiController
  doorkeeper_for :all

  def index
    page = (params[:page] || 1).to_i
    expires_in 5.seconds
    if page > 1 || stale?(last_modified: current_user.posts.maximum(:updated_at))
      @posts = current_user.posts.alive.order("updated_at DESC").page(page)
    end
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

  def destroy
    @post = current_user.posts.find_by_id(params[:id])
    @post.update_attribute(:deleted_at, Time.now)
    render :action => :show
  end
end
