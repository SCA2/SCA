class UserMailerPreview < ActionMailer::Preview

  def signup_confirmation
    user = User.first
    UserMailer.signup_confirmation(user)
  end

  def password_reset
    user = User.first
    UserMailer.password_reset(user)
  end
  
  def order_received
    order = Order.last
    UserMailer.order_received(order)
  end

  def order_shipped
    order = Order.last
    UserMailer.order_shipped(order)
  end

end