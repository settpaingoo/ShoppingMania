class WishlistsController < ApplicationController
  before_filter :require_current_user!

  def index
    @wishlists = current_user.wishlists
  end

  def create
    wishlist = current_user.wishlists.new(params[:wishlist])
    unless wishlist.save
      flash[:errors] = "Couldn't create new wishlist"
    end

    redirect_to wishlists_url
  end

  def destroy
    wishlist = Wishlist.find(params[:id])
    wishlist.destroy
    redirect_to wishlists_url
  end
end
