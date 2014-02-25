class CartItemsController < ApplicationController
  before_filter :ensure_cart

  def create
    cart = get_cart
    quantity = params[:cart_item][:quantity].to_i

    begin
      cart.add_item(params[:item_id], quantity)
      flash[:notice] = "Item has been added to your cart"
    rescue
      flash[:error] = "Could not add item to the cart"
    end

    if request.xhr?
      render json: { status_messages: status_messages }
      clear_flash
    else
      redirect_to cart_url(cart)
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    new_quantity = params[:cart_item][:quantity].to_i

    begin
      updated_cart_item = cart_item.modify(new_quantity)
      flash[:notice] = "Successfully updated"
    rescue
      flash[:error] = "Couldn't update the item"
    end

    if request.xhr?
      render json: { total: cart_item.cart.total, subtotal: updated_cart_item.subtotal, status_messages: status_messages }
      clear_flash
    else
      redirect_to cart_url(current_user.cart)
    end
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.remove

    if request.xhr?
      render json: { total: cart_item.cart.total }
    else
      redirect_to cart_url(current_user.cart)
    end
  end

  def save_for_later
    cart_item = CartItem.includes(:item).find(params[:cart_id])
    begin
      CartItem.transaction do
        cart_item.item.add_stock(cart_item.quantity)
        cart_item.quantity = 0
        cart_item.save!
      end
    rescue
      flash[:error] = "Could not save the item"
    ensure
      redirect_to cart_url(cart_item.cart)
    end
  end

end
