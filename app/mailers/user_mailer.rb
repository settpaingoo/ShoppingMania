class UserMailer < ActionMailer::Base
  default from: "no_reply@shoppingmania.com"

  def welcome_email(user)
    token = Token.create(user_id: user.id)
    @activation_token = token.token_string
    mail(to: user.email, subject: "Welcome to Shopping Mania")
  end

  def password_reset_email(user)
    token = Token.create(user_id: user.id)
    @password_reset_token = token.token_string
    mail(to: user.email, subject: "Reset your password")
  end

  def order_confirmation_email(user, order)
    @order = order
    mail(to: user.email, subject: "Order Confirmation")
  end
end
