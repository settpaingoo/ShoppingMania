module SessionsHelper

  def current_user
    return @current_user if @current_user

    token = Token.find_by_token_string(session[:session_token])
    token.nil? ? nil : @current_user = token.user
  end

  def sign_in(user)
    @current_user = user
    current_cart = Cart.build_temporary_cart(session[:cart_item_params])
    user.cart.combine(current_cart)

    token = Token.create(user_id: user.id)
    session[:session_token] = token.token_string
    session[:cart_item_params] = nil
  end

  def sign_out
    token = Token.find_by_token_string(session[:session_token])
    token.destroy
    session[:session_token] = nil
  end

end
