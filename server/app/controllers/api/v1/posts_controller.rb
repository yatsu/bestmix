class Api::V1::PostsController < Api::ApiController
  # before_filter :authenticate_user!, except: [ :public ]
  doorkeeper_for :my

  def published
    page = (params[:page] || 1).to_i
    @posts = Post.published.page(page)
  end

  def my
    page = (params[:page] || 1).to_i
    @posts = Post.my(current_user).page(page)
  end

  def show
    @post = Post.find_by_id(params[:id])
  end

  def create
    @post = current_user.posts.create(
      :title => params[:title],
      :content => params[:content],
      :published_at => params[:published] == "true" ? Time.now : nil
    )
    logger.debug "create post: #{@post.inspect} valid: #{@post.valid?}"

    unless @post.valid?
      logger.debug @post.errors.inspect
      @error = ApiError.new(
        :invalid_parameter,
        "Parameter Error",
        @post.errors.messages
      )
      render :action => :error
      return
    end

    render :action => :show
  end
end
