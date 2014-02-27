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

    if current_user
      cart_item = CartItem.find(params[:id])
      if cart_item.update_attributes(quantity: new_quantity)
        flash[:notice] = "Successfully updated"
      else
        flash[:error] = "Could not update the item"
      end
    else
      if new_quantity > 0
        session[:cart_item_params][params[:id].to_i] = new_quantity
        flash[:notice] = "Successfully updated"
      else
        flash[:error] = "Could not update the item"
      end
    end

    redirect_to cart_url(current_user.try(:cart) || "temp")
  end

  def destroy
    if current_user
      cart_item = CartItem.find(params[:id])
      cart_item.destroy
      cart = cart_item.cart
    else
      session[:cart_item_params].delete(params[:id].to_i)
      cart = Cart.build_temporary_cart(session[:cart_item_params], [])
    end

    if request.xhr?
      render json: { total: cart.total }
    else
      redirect_to cart_url(current_user.try(:cart) || "temp")
    end
  end

end
