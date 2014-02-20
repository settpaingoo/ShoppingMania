class WishlistItemsController < ApplicationController
  def create
    wishlist_item = WishlistItem.new(wishlist_id: params[:wishlist][:id], item_id: params[:item_id])
    if wishlist_item.save
      flash[:notice] = "Item has been added to the wishlist"
    else
      flash[:errors] = "Couldn't add the item to wishlist"
    end

    redirect_to item_url(params[:item_id])
  end
end
