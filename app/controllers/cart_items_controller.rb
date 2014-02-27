class CartItemsController < ApplicationController

  def create
    quantity = params[:cart_item][:quantity].to_i

    begin
      if current_user
        current_user.cart.add_item(params[:item_id], quantity)
      else
        raise "error" unless quantity > 0
        session[:cart_item_params] ||= {}
        session[:cart_item_params][params[:item_id].to_i] = quantity
        session[:saved_item_ids].try(:delete, params[:item_id].to_i)
      end
      flash[:notice] = "Item has been added to your cart"
    rescue
      flash[:error] = "Could not add item to your cart"
    end

    if request.xhr?
      render json: { status_messages: status_messages }
      clear_flash
    else
      redirect_to cart_url(current_user.try(:cart) || "temp")
    end
  end

  def update
    new_quantity = params[:cart_item][:quantity].to_i
    new_quantity = 1 if new_quantity < 1

    if current_user
      cart_item = CartItem.find(params[:id])
      cart_item.update_attributes(quantity: new_quantity)
    else
      session[:cart_item_params][params[:id].to_i] = new_quantity
      cart_item = CartItem.new(item_id: params[:id].to_i, quantity: new_quantity)
      cart_item.cart = Cart.build_temporary_cart(params[:cart_item_params])
    end
    flash[:notice] = "Item has been updated"

    if request.xhr?
      render json: {
        status_messages: status_messages,
        quantity: new_quantity,
        subtotal: cart_item.subtotal,
        total: cart_item.cart.total
      }
      clear_flash
    else
      redirect_to cart_url(current_user.try(:cart) || "temp")
    end
  end

  def destroy
    if current_user
      cart_item = CartItem.find(params[:id])
      cart_item.destroy
      cart = cart_item.cart
    else
      session[:cart_item_params].delete(params[:id].to_i)
      cart = Cart.build_temporary_cart(session[:cart_item_params])
    end

    if request.xhr?
      render json: { total: cart.total }
    else
      redirect_to cart_url(current_user.try(:cart) || "temp")
    end
  end

end
