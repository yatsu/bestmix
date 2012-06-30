class Api::ApiController < ApplicationController
  # include Doorkeeper::Controller

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def render_error(error, error_description, messages)
    render :json => ApiError.json(error, error_description, messages)
  end

  private

  def current_user
    if doorkeeper_token
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
