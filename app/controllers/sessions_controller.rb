class SessionsController < ApplicationController
  before_filter :require_current_user!, only: :destroy

  def new
    @demo_user = User.find(1)
  end

  def create
    if request.env['omniauth.auth']
      auth = request.env['omniauth.auth']
      user = User.find_by_uid(auth[:uid]) || User.create_from_fb_data(auth)
      user.cart || user.create_cart
    else
      user = User.find_by_credentials(
        params[:user][:email],
        params[:user][:password]
      )
    end

    if user.try(:activated?)
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
      @demo_user = User.find(1)
      render :new
    end
  end

  def destroy
    if current_user.id == 1
      current_user.update_attributes(
        first_name: "Demo",
        last_name: "User",
        email: "user1@example.com",
        password: "mypassword"
      )
    end

    sign_out
    redirect_to new_session_url
  end
end
