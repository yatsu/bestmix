class Api::ApiController < ApplicationController
  # include Doorkeeper::Controller

  respond_to :json

  private

  def current_user
    if doorkeeper_token
      @current_user ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
