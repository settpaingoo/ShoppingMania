class SavedItemsController < ApplicationController
  def create
    if current_user
      current_user.cart.save_item(params[:item_id])
    else
      session[:saved_item_ids] ||= []
      session[:saved_item_ids] << params[:item_id].to_i
      session[:cart_item_params].delete(params[:item_id].to_i)
    end

    redirect_to cart_url(current_user.try(:cart) || "temp")
  end

  def destroy
    if current_user
      saved_item = SavedItem.find(params[:id])
      saved_item.destroy
    else
      session[:saved_item_ids].delete(params[:id].to_i)
    end

    redirect_to cart_url(current_user.try(:cart) || "temp")
  end
end
