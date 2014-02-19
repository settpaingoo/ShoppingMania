class ItemsController < ApplicationController
  before_filter :require_admin!, only: [:new, :create, :edit, :update]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    @item.photos.build([params[:photos]])

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
    if params[:photos]
      @item.photos.build([params[:photos]])
    end

    if @item.update_attributes(params[:item])
      flash[:notice] = "Item has been successfully updated"
      redirect_to user_url(current_user)
    else
      flash[:errors] = "Could not update the item"
      render :edit
    end
  end

  def index
    params[:brand_ids] && params[:brand_ids].map!(&:to_i)
    params[:category_ids] && params[:category_ids].map!(&:to_i)

    if params[:price]
      params[:price][:min] = params[:price][:min].to_i
      params[:price][:max] = params[:price][:max].to_i
      @items = Item.filter(params)
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to user_url(current_user)
  end
end
