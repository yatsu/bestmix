class MainController < ApplicationController
  def index
    if user_signed_in?
      @my_tasks = current_user.tasks
    end

    page = (params[:page] || 1).to_i
    @public_tasks = Task.pub.page(page)
  end
end
