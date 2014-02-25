class SessionsController < ApplicationController
  before_filter :require_current_user!, only: :destroy
  before_filter :ensure_cart, only: :new

  def new
  end

  def create
    if request.env['omniauth.auth']
      auth = request.env['omniauth.auth']
      user = User.find_by_uid(auth[:uid]) || User.create_from_fb_data(auth)
    else
      user = User.find_by_credentials(
        params[:user][:email],
        params[:user][:password]
      )
    end

    if user && user.activated?
      sign_in(user)
      if session[:request_uri]
        redirect_to session[:request_uri]
        session[:request_uri] = nil
      else
        redirect_to root_url
      end
    else
      if user.nil?
        flash[:error] = "Incorrect email/password combination"
      else
        flash[:error] = "Please check your email and activate your account"
      end
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to new_session_url
  end
end
