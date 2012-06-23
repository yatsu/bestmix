class Api::V1::TasksController < Api::ApiController
  # before_filter :authenticate_user!, except: [ :public ]
  doorkeeper_for :my

  def public
    page = (params[:page] || 1).to_i
    @tasks = Task.pub.page(page)
  end

  def my
    page = (params[:page] || 1).to_i
    @tasks = Task.my(current_user).page(page)
  end

  def show
    @task = Task.find_by_id(params[:id])
  end

  def create
    @task = current_user.tasks.create(
      :name => params[:name],
      :public => params[:public]
    )
    logger.debug "create task: #{@task.inspect} valid: #{@task.valid?}"

    unless @task.valid?
      logger.debug @task.errors.inspect
      @error = ApiError.new(
        :invalid_parameter,
        "Parameter Error",
        @task.errors.messages
      )
      render :action => :error
      return
    end

    render :action => :show
  end
end
