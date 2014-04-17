class UserMailer < ActionMailer::Base

  default from: "admin@seventhcircleaudio.com"
  default return_path: "admin@seventhcircleaudio.com"
  default date: Time.now
  default content_type: "text/html"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "SCA Signup Confirmation"
  end
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end
  
  def order_received(order)
    @transaction = order.transactions.first
    @cart = order.cart
    @order = order
    @billing = order.addresses.find_by(address_type: 'billing')
    @shipping = order.addresses.find_by(address_type: 'shipping')
    mail to: order.email, subject: "Thank you for your order"
  end

  def order_shipped(user)
    mail to: user.email, subject: "Your Seventh Circle Audio order has shipped!"
  end
end
