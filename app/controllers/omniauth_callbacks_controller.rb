class OmniauthCallbacksController < ApplicationController
  # 谷歌授权登录
  def google_oauth2
    authenticate "Google"
  end

  # facebook授权登录
  def facebook
		authenticate "Facebook"
	end

  # Github授权登录
  def github
		authenticate "Github"
	end

  private

  def authenticate(kind)
    @user = User.identify(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.user_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
