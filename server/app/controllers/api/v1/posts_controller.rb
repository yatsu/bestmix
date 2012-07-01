class Api::V1::PostsController < Api::ApiController
  def index
    expires_in 5.seconds
    if stale? last_modified: Post.maximum(:updated_at)
      @posts = Post.published.alive.order("updated_at DESC").page((params[:page] || 1).to_i)
    end
  end

  def show
    @post = Post.published.alive.find_by_id(params[:id])
    if @post.nil?
      @error = ApiError.new(
        :resource_not_found,
        "Not Found",
        "Requested post does not exist or you don't have permission to see it."
      )
      render :action => :error
      return
    end
    expires_in 5.seconds
    fresh_when @post, public: true
  end
end
