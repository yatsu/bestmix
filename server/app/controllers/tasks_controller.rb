class TasksController < InheritedResources::Base
  before_filter :authenticate_user!

  def index
    redirect_to root_path
  end

  def create
    create! { root_path }
    @task.user = current_user
    @task.save
  end
end
