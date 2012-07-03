class OmniauthCallbacksController < ApplicationController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      unless @user.valid?
        flash[:notice] = @user.errors.full_messages.join(". ") + "."
        redirect_to new_user_session_path
        return
      end
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end
end
