class OrdersController < ApplicationController

  def index
    #sort by order date(most recent one on top)
    @orders = current_user.orders
  end

  def create
    cart = current_user.cart

    if cart.checkout
      #after call_back in the model
      current_user.create_cart
      redirect_to categories_url
    else
      flash[:errors] = "Something went wrong with checkout process"
      redirect_to cart_url(cart)
    end
  end
end