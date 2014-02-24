class WishlistItemsController < ApplicationController
  def create
    wishlist_item = WishlistItem.new(
      wishlist_id: params[:wishlist].try(:[], :id),
      item_id: params[:item_id]
    )
    if wishlist_item.save
      flash[:notice] = "Item has been added to your wishlist"
    else
      flash[:error] = "Please select a wishlist or create a new one"
    end

    if request.xhr?
      render partial: "items/status_messages", layout: false
      clear_flash
    else
      redirect_to item_url(params[:item_id])
    end
  end
end
