class UsersController < ApplicationController
  before_filter :require_current_user!, except: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in(@user)
      redirect_to categories_url
    else
      flash[:errors] = "Could not create a new account"
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    filter_user_password_params(params)
    @user = current_user

    if params[:user][:password]
      update_status = @user.authenticate(params[:old_password]) &&
        @user.update_attributes(params[:user])
    else
      update_status = @user.update_attributes(params[:user])
    end

    if update_status
      flash[:notice] = "Successfully updated"
      redirect_to user_url(@user)
    else
      flash[:errors] = "Could not update user information"
      render :edit
    end
  end

  def show
    @user = current_user
    render :show
  end
end
