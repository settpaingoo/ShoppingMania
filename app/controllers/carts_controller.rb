class CartsController < ApplicationController

  def show
    @cart = Cart.includes(cart_items: :item).find(current_user.cart.id)
  end
end
