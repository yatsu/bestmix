class Api::V1::PostsController < Api::ApiController
  def index
    @posts = Post.published.page((params[:page] || 1).to_i)
    expires_in 5.seconds
    # fresh_when @posts.first, public: true
    fresh_when last_modified: @posts.maximum(:updated_at), public: true
  end

  def show
    @post = Post.published.find_by_id(params[:id])
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
