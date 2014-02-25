class OrdersController < ApplicationController

  def index
    @orders = current_user.orders.includes(:address)
  end

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
      #delayed job
      flash[:notice] = "Order confirmation email has been sent to your email address"
      redirect_to orders_url
    rescue
      flash[:error] = "Something went wrong with checkout process"
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
