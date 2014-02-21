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
    else
      flash[:errors] = @review.errors.full_messages
    end

    redirect_to item_url(params[:item_id])
  end
end
