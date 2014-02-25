class WishlistItemsController < ApplicationController
  before_filter :require_current_user!

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
      render json: { status_messages: status_messages }
      clear_flash
    else
      redirect_to item_url(params[:item_id])
    end
  end

  def destroy
    wishlist_item = Wishlist.find(params[:id])
    wishlist_item.destroy
    redirect_to wishlists_url
  end

end
