class CartsController < ApplicationController

  def show
    if current_user
      @cart =  current_user.cart
    else
      @cart = Cart.build_temporary_cart(session[:cart_item_params])
    end
  end
end