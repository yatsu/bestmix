class MainController < ApplicationController
  def index
    page = (params[:page] || 1).to_i

    if user_signed_in?
      @my_posts = current_user.posts.page(page)
    end

    @public_posts = Post.published.page(page)
  end
end
