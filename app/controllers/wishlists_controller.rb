class WishlistsController < ApplicationController

  def index
    @wishlists = current_user.wishlists
  end
end
