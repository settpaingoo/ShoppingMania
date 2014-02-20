class UsersController < ApplicationController
  before_filter :require_current_user!, only: [:edit, :update, :show]
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver!
      flash[:notice] = "Please check your email to activate your account"
      redirect_to new_session_url
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

  def activate
    token = Token.find_by_token_string(params[:activation_token])

    if token
      user = token.user
      user.activated = true
      user.save!

      token.destroy
      sign_in(user)
      redirect_to root_url
    else
      flash[:errors] = "Couldn't find the associated account"
      redirect_to new_user_url
    end
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
    UserMailer.password_reset_email(user).deliver!
    flash[:notice] = "Please check your email for password reset link"
    redirect_to new_user_url
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
      flash[:errors] = "Please choose a valid password"
      render :reset_password
    end
  end
end
