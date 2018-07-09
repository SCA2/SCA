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

  class Customer
    attr_accessor :name, :email
    def initialize(name, email)
      @name = name
      @email = email
    end
  end

  def invoice
    cart = FactoryBot.create(:cart)
    product = FactoryBot.create(:product, product_category_id: 1, model: 'M80', model_sort_order: '100')
    option = FactoryBot.create(:option, product: product)
    line_item = FactoryBot.create(:line_item, cart: cart, product: product, option: option, quantity: 1)
    customer = Customer.new('Joe Tester', 'joe.tester@example.com')
    mail = UserMailer.invoice(cart: cart, customer: customer)
    cart.destroy
    product.destroy
    option.destroy
    line_item.destroy
    mail
  end

end