class CartsController < ApplicationController
  before_filter :ensure_cart

  def show
    @cart =  get_cart
  end
end