class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  def require_current_user!
    unless current_user
      session[:request_uri] = request.env["REQUEST_URI"]
      redirect_to new_session_url
    end
  end

  def require_admin!
    redirect_to root_url unless current_user.admin?
  end

  def ensure_cart
    unless (session[:cart_id] || current_user)
      cart = Cart.create
      session[:cart_id] = cart.id
    end
  end

  def avoid_empty_orders
    cart = current_user.cart
    redirect_to cart_url(cart) if cart.cart_items.empty?
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
    filter_params.delete(:rating) if filter_params[:rating].empty?

    if filter_params[:price].empty?
      filter_params.delete(:price)
    else
      min = filter_params[:price][:min]
      max = filter_params[:price][:max]

      params[:filter][:price][:min] = min.to_i if min
      params[:filter][:price][:max] = max.to_i if max
    end

    params[:filter][:rating] = filter_params[:rating].to_i if filter_params[:rating]

    filter_params[:brand_ids].map!(&:to_i) if filter_params[:brand_ids]
    filter_params[:category_ids].map!(&:to_i) if filter_params[:category_ids]
  end

  def clear_flash
    flash[:notice] = nil
    flash[:error] = nil
    flash[:errors] = nil
  end
end
