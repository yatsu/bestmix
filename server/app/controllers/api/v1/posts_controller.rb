class Api::V1::PostsController < Api::ApiController
  inherit_resources
  actions :index, :show
  has_scope :page, :default => 1

  def index
    @posts = Post.published.page((params[:page] || 1).to_i)
  end

  def show
    show! do
      if @post.nil?
        @error = ApiError.new(
          :resource_not_found,
          "Not Found",
          "Requested post does not exist or you don't have permission to see it."
        )
        render :action => :error
        return
      end
    end
  end

  private

  def collection
    @posts ||= end_of_association_chain.published
  end

  def resource
    @post = Post.where("published_at IS NOT NULL").find_by_id(params[:id])
  end
end
