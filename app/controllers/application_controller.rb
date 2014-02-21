class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  def require_current_user!
    redirect_to new_session_url unless current_user
  end

  def require_admin!
    redirect_to root_url unless current_user.admin?
  end

  def filter_user_password_params(params)
    if (params[:user][:password].empty? && params[:user][:password_confirmation].empty?)
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
  end

  def parse_filter_params
    filter_params = params[:filter]

    filter_params.delete(:name) if filter_params[:name].empty?

    filter_params[:price].delete(:min) if filter_params[:price][:min].empty?
    filter_params[:price].delete(:max) if filter_params[:price][:max].empty?

    if filter_params[:price].empty?
      filter_params.delete(:price)
    else
      params[:filter][:price] = filter_params[:price].map { |k,v| {k => v.to_i} }
    end

    filter_params[:brand_ids].map!(&:to_i) if filter_params[:brand_ids]
    filter_params[:category_ids].map!(&:to_i) if filter_params[:category_ids]
  end
end
