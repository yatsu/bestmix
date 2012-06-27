class MainController < ApplicationController
  def index
    if user_signed_in?
      @my_posts = current_user.posts
    end

    page = (params[:page] || 1).to_i
    @public_posts = Post.published.page(page)
  end
end
