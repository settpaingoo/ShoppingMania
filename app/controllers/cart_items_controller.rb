class CartItemsController < ApplicationController

  def create
    cart = current_user.cart
    quantity = params[:cart_item][:quantity].to_i

    begin
      cart.add_item(params[:item_id], quantity)
      flash[:notice] = "Item has been added to your cart"
    rescue
      flash[:error] = "Couldn't add item to the cart"
    ensure
      if request.xhr?
        render partial: "items/status_messages", layout: false
        clear_flash
      else
        redirect_to item_url(params[:item_id])
      end
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    new_quantity = params[:cart_item][:quantity].to_i

    begin
      cart_item.modify(new_quantity)
      flash[:notice] = "Successfully updated"
    rescue
      flash[:error] = "Couldn't update the item"
    end

    redirect_to cart_url(current_user.cart)
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.remove
    redirect_to cart_url(current_user.cart)
  end

end
