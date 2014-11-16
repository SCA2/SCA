class UserMailer < ActionMailer::Base

  # include Roadie::Rails::Automatic

  default css: "mailers.css.scss"
  default from: "sales@seventhcircleaudio.com"
  default return_path: "sales@seventhcircleaudio.com"
  default date: Time.now
  default content_type: "text/html"

  def signup_confirmation(user)
    @user = user
    mail to: user.email, subject: "SCA Signup Confirmation"
  end
  
  def password_reset(user)
    @user = user
    byebug
    mail to: user.email, subject: "Password Reset"
  end
  
  def order_received(order)
    @transaction = order.transactions.first
    @cart = order.cart
    @order = order
    @billing = order.addresses.find_by(address_type: 'billing')
    @shipping = order.addresses.find_by(address_type: 'shipping')
    mail  to: order.email, 
          bcc: "orders@seventhcircleaudio.com",
          subject: "Thank you for your order"
  end

  def order_shipped(user)
    @user = user
    mail to: user.email, subject: "Your Seventh Circle Audio order has shipped!"
  end
end
