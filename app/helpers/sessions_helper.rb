module SessionsHelper

  def current_user
    return @current_user if @current_user

    token = Token.find_by_token_string(session[:session_token])
    token.nil? ? nil : @current_user = token.user
  end

  def sign_in(user)
    token = Token.create(user_id: user.id)

    @current_user = user
    current_cart = Cart.find(session[:cart_id])
    current_cart.combine(user.cart)

    session[:session_token] = token.token_string
    session[:cart_id] = nil
  end

  def sign_out
    token = Token.find_by_token_string(session[:session_token])
    token.destroy
    session[:session_token] = nil
  end

  def get_cart
    current_user ? current_user.cart : Cart.find(session[:cart_id])
  end

end
