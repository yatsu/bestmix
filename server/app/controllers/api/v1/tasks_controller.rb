class Api::V1::TasksController < Api::ApiController
  # before_filter :authenticate_user!, except: [ :public ]
  doorkeeper_for :my

  def public
    page = (params[:page] || 1).to_i
    @tasks = Task.pub.page(page)
  end

  def my
    page = (params[:page] || 1).to_i
    @tasks = Task.pub.page(page)
  end

  def show
    @task = Task.find_by_id(params[:id])
  end
end
