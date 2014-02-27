class OrdersController < ApplicationController
  before_filter :require_current_user!
  before_filter :avoid_empty_orders, only: [:new, :create]

  def index
    @orders = current_user.orders.includes(:address)
  end

  #add styles to orders/new
  def new
    @cart = current_user.cart
    @addresses = current_user.addresses
  end

  def create
    cart = current_user.cart
    order = Order.new(user_id: current_user.id, address_id: params[:address][:id])

    begin
      order.checkout(cart)
      UserMailer.order_confirmation_email(current_user, order).deliver!
      #change to delayed job
      flash[:notice] = "Order confirmation email has been sent to your email address"
      redirect_to orders_url
    rescue
      flash[:error] = "Please check your cart again"
      redirect_to cart_url(cart)
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
    if @order
      render :show
    else
      redirect_to orders_url
    end
  end
end
