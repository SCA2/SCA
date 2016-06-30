class Order < ActiveRecord::Base

  belongs_to :cart, inverse_of: :order
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :transactions

  accepts_nested_attributes_for :addresses

  def billing_address
    addresses.billing_address
  end

  def shipping_address
    addresses.shipping_address
  end

  def purchased?
    cart && cart.purchased?
  end

  def addressable?
    cart && !cart.line_items_empty?
  end

  def shippable?
    billing_address &&
    shipping_address &&
    addressable?
  end

  def confirmable?
    shipping_method && shipping_cost && shippable?
  end

  def standard_purchase?
    express_token.blank? && confirmable?
  end

  def express_purchase?
    !express_token.blank? && confirmable?
  end

  def notifiable?
    email && confirmable?
  end

  def purchased_at
    cart.purchased_at
  end

  def subtotal
    cart.subtotal
  end

  def total
    cart.subtotal + shipping_cost + sales_tax
  end

end