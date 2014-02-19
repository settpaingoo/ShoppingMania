class ItemsController < ApplicationController
  before_filter :require_admin!, only: [:new, :create, :edit, :update]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = "New item has been added"
      redirect_to user_url(current_user)
    else
      flash[:errors] = "Could not create new item"
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      flash[:notice] = "Item has been successfully updated"
      redirect_to user_url(current_user)
    else
      flash[:errors] = "Could not update the item"
      render :edit
    end
  end

  def index
    if params[:price]
      params[:price][:min] = params[:price][:min].to_i
      params[:price][:max] = params[:price][:max].to_i
    end

    if params[:brand_ids]
      params[:brand_ids] = params[:brand_ids].map(&:to_i)
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
