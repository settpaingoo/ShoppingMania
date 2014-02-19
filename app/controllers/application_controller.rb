class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  def require_current_user!
    redirect_to new_session_url unless current_user
  end

  def filter_user_password_params(params)
    if (params[:user][:password].empty? && params[:user][:password_confirmation].empty?)
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
  end
end
