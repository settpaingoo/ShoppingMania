module SessionsHelper

  def current_user
    return @current_user if @current_user

    token = Token.find_by_token_string(session[:session_token])
    token.nil? ? nil : @current_user = token.user
  end

  def sign_in(user)
    token = Token.create(user_id: user.id)
    @current_user = user
    user.cart || user.create_cart
    session[:session_token] = token.token_string
  end

  def sign_out
    token = Token.find_by_token_string(session[:session_token])
    token.destroy
    session[:session_token] = nil
  end

end
