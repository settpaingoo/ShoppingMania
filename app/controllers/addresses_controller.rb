class AddressesController < ApplicationController

  def index
    @addresses = current_user.addresses
    @address = Address.new
  end

  def create
    @address = Address.new(params[:address])
    @address.user_id = current_user.id

    if @address.save
      redirect_to addresses_url
    else
      flash[:errors] = @address.errors.full_messages
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = current_user.addresses.find(params[:id])
    if @address.try(:update_attributes, params[:address])
      flash[:notice] = "Successfully updated the address"
      redirect_to addresses_url
    else
      flash[:errors] = @address.errors.full_messages
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    if address.orders.empty?
      address.destroy
    else
      address.user_id = nil
      address.save
    end

    redirect_to addresses_url
  end
end
