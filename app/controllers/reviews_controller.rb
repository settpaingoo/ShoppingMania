class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review])
    @review.user_id = current_user.id
    @review.item_id = params[:item_id]

    if @review.save
      flash[:notice] = "Thank you for writing the review"
      redirect_to item_url(params[:item_id])
    else
      flash[:errors] = "Could not add the review"
      render :new
    end
  end
end
