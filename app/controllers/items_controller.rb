class ItemsController < ApplicationController

  def index
    if params[:price]
      params[:price][:min] = params[:price][:min].to_i
      params[:price][:max] = params[:price][:max].to_i
    end

    items = Item.where(["category_id = ?", params[:category_id]])
    @items = Item.filter(items, params)
    category_brand_ids = items.map(&:brand_id).uniq
    @brands = Brand.find(category_brand_ids)
  end

  def show
    @item = Item.find(params[:id])
  end
end
