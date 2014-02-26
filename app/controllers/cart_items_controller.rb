class CartItemsController < ApplicationController

  def create
    quantity = params[:cart_item][:quantity]

    if current_user
      cart = current_user.cart
      begin
        cart.add_item(params[:item_id], quantity.to_i)
        flash[:notice] = "Item has been added to your cart"
      rescue
        flash[:error] = "Could not add item to the cart"
      end
    else
      session[:cart_item_params] ||= {}
      session[:cart_item_params][params[:item_id].to_i] = quantity
      flash[:notice] = "Item has been added to your cart"
      cart = "dummy"
    end

    if request.xhr?
      render json: { status_messages: status_messages }
      clear_flash
    else
      redirect_to cart_url(cart)
    end
  end

  def update
    new_quantity = params[:cart_item][:quantity]

    if current_user
      cart_item = CartItem.find(params[:id])
      begin
        updated_cart_item = cart_item.modify(new_quantity.to_i)
        flash[:notice] = "Successfully updated"
      rescue
        flash[:error] = "Couldn't update the item"
      end
    else
      session[:cart_item_params][params[:id].to_i] = new_quantity
      updated_cart_item = CartItem.new(item_id: params[:id], quantity: new_quantity.to_i)
      updated_cart_item.cart = Cart.build_temporary_cart(session[:cart_item_params])
      flash[:notice] = "Successfully updated"
    end

    if request.xhr?
      render json: { total: updated_cart_item.cart.total, subtotal: updated_cart_item.subtotal, status_messages: status_messages }
      clear_flash
    else
      redirect_to cart_url(current_user.cart)
    end
  end

  def destroy
    if current_user
      cart_item = CartItem.find(params[:id])
      cart_item.remove
      cart = cart_item.cart
    else
      session[:cart_item_params].delete(params[:id].to_i)
      cart = Cart.build_temporary_cart(session[:cart_item_params])
    end

    if request.xhr?
      render json: { total: cart.total }
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
