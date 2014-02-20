class OrdersController < ApplicationController

  def index
    #sort by order date(most recent one on top)
    @orders = current_user.orders
  end

  def create
    cart = current_user.cart
    order = cart.checkout
    if order
      #after call_back in the model
      current_user.create_cart
      UserMailer.order_confirmation_email(current_user, order).deliver!
      redirect_to root_url
    else
      flash[:errors] = "Something went wrong with checkout process"
      redirect_to cart_url(cart)
    end
  end
end
