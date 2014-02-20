class WishlistsController < ApplicationController

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
end
