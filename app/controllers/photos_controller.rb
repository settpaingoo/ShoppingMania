class PhotosController < ApplicationController
  before_filter :require_admin!

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy
    redirect_to edit_item_url(photo.item_id)
  end
end
