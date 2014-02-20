class UserMailer < ActionMailer::Base
  default from: "no_reply@shoppingmania.com"

  def welcome_email(user)
    token = Token.create(user_id: user.id)
    @url = Addressable::URI.new(
      scheme: "http",
      host: "localhost:3000",
      path: "/users/activate",
      query_values: { activation_token: token.token_string }
    ).to_s
    mail(to: user.email, subject: "Welcome to Shopping Mania")
  end

  def password_reset_email(user)
    token = Token.create(user_id: user.id)
    @url = Addressable::URI.new(
      scheme: "http",
      host: "localhost:3000",
      path: "/users/reset_password",
      query_values: { password_reset_token: token.token_string }
    ).to_s
    mail(to: user.email, subject: "Reset your password")
  end

  def order_confirmation_email(user, order)
    @order = order
    mail(to: user.email, subject: "Order Confirmation")
  end
end
