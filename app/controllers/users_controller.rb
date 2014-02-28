class UsersController < ApplicationController
  before_filter :require_current_user!, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.cart = Cart.build_temporary_cart(
      session[:cart_item_params],
      session[:saved_item_ids]
    )

    if @user.save
      UserMailer.welcome_email(@user).deliver!
      flash[:notice] = "Please check your email to activate your account"
      session[:cart_item_params] = nil
      session[:saved_item_ids] = nil
      redirect_to new_session_url
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def show
    if params[:id].to_i == current_user.id
      @user = current_user
      render :show
    else
      redirect_to user_url(current_user)
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
      redirect_to edit_user_url(@user)
    else
      flash[:errors] = "Could not update user information"
      render :edit
    end
  end

  def activate
    token = Token.find_by_token_string(params[:activation_token])
    token.destroy

    user = token.user
    user.activated = true
    user.save!
    sign_in(user)

    redirect_to root_url
  end

  def reset_password
    if params[:password_reset_token]
      render :reset_password
    else
      render :request_token
    end
  end

  def send_password_token
    user = User.find_by_email(params[:user][:email])
    if user
      UserMailer.password_reset_email(user).deliver!
      flash[:notice] = "Please check your email for the link to reset your password"
      redirect_to new_session_url
    else
      flash[:error] = "Could not find the user with given email"
      redirect_to :back
    end
  end

  def update_password
    token = Token.find_by_token_string(params[:password_reset_token])
    user = token.user
    if user.update_attributes(params[:user])
      flash[:notice] = "You have successfully changed your password"
      token.destroy
      sign_in(user)
      redirect_to root_url
    else
      flash[:errors] = user.errors.full_messages
      render :reset_password
    end
  end
end
