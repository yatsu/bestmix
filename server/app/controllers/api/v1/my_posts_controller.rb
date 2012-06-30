class Api::V1::MyPostsController < Api::ApiController
  inherit_resources
  defaults :resource_class => Post, :collection_name => 'posts', :instance_name => 'post'
  actions :index, :show, :create, :update, :destroy
  has_scope :page, :default => 1

  doorkeeper_for :all

  def show
    show! do
      if @post.nil?
        render_error(
          :resource_not_found,
          "Not Found",
          "Requested post does not exist or you don't have permission to see it."
        )
        return
      end
    end
  end

  def create
    create! do |success, failure|
      failure.json do
        render_error(:invalid_parameter, "Parameter Error", @post.errors.messages)
      end
      success.json do
        render :action => :show
      end
    end
  end

  def update
    update! do |success, failure|
      failure.json do
        render_error(:invalid_parameter, "Parameter Error", @post.errors.messages)
      end
      success.json do
        render :action => :show
      end
    end
  end

  private

  def begin_of_association_chain
    current_user
  end

  def collection
    @posts ||= end_of_association_chain.order("updated_at DESC")
  end
end
