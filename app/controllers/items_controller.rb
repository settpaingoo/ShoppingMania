class ItemsController < ApplicationController
  before_filter :require_admin!, except: [:index, :show]

  #chosen js plug-in for searchbox
  def index
    parse_filter_params if params[:filter]

    items = Item.filter(params[:filter])
    @items = Item.sort(items, params[:sort]).page(params[:page])

    if request.xhr?
      render partial: "items", locals: { items: @items }, layout: false
    else
      render :index
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(params[:item])
    photo_params = params[:photos].values
    @item.photos.new(photo_params)

    if @item.save
      flash[:notice] = "New item has been added"
      redirect_to item_url(@item)
    else
      flash[:errors] = @item.errors.full_messages
      render :new
    end
  end

  def show
    @item = Item.includes(:photos).find(params[:id])
    @photo = @item.photos.first
    @wishlists = current_user.try(:wishlists)
    @item_rating = @item.average_rating
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:photos]
      @item.photos.new([params[:photos]])
    end

    if @item.update_attributes(params[:item])
      flash[:notice] = "Item has been successfully updated"
      redirect_to edit_item_url(@item)
    else
      flash[:errors] = @item.errors.full_messages
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to user_url(current_user)
  end

  def admin_shortcut
    if params[:item_id].empty?
      redirect_to edit_item_url(Item.first)
    else
      redirect_to edit_item_url(params[:item_id])
    end
  end
end
