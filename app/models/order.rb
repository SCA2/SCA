class Order < ActiveRecord::Base

  belongs_to :cart, inverse_of: :order
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :transactions

  accepts_nested_attributes_for :addresses

  delegate :purchased?, :purchased_at, :subtotal, :min_dimension, :max_dimension, :total_volume, :weight, to: :cart

  scope :checked_out, -> do
    Order.joins('INNER JOIN addresses ON addresses.addressable_id = orders.id', :cart, :transactions)
  end

  scope :successful, -> do
    checked_out.where(transactions: {success: true}).
    order(created_at: :desc).distinct
  end

  scope :failed, -> do
    where.not(id: checked_out.where(transactions: {success: true}).select(:id)).
    order(created_at: :desc).distinct
  end

  scope :pending, -> do
    successful.where(transactions: {shipped_at: nil, tracking_number: nil}).
    order(created_at: :desc).distinct
  end

  scope :shipped, -> do
    checked_out.where(transactions: {success: true}).
    where.not(transactions:{shipped_at: nil, tracking_number: nil}).
    order(created_at: :desc).distinct
  end

  scope :abandoned, -> do
    joins('INNER JOIN addresses ON addresses.addressable_id = orders.id', :cart).
    where(carts: {purchased_at: nil})
  end

  def billing_address
    addresses.billing_address
  end

  def shipping_address
    addresses.shipping_address
  end

  def addressable?
    cart && !cart.line_items_empty?
  end

  def shippable?
    addressable? &&
    billing_address.present? &&
    shipping_address.present?
  end

  def payable?
    shippable? && shipping_method && shipping_cost
  end

  def confirmable?
    payable? && token_present? && email.present?
  end

  def token_present?
    express_token.present? || stripe_token.present?
  end

  def stripe_purchase?
    stripe_token.present? && express_token.blank? && payable?
  end

  def express_purchase?
    express_token.present? && stripe_token.blank? && payable?
  end

  def transactable?
    confirmable? && confirmed
  end

  def total
    subtotal + shipping_cost + sales_tax
  end

  def carrier
    if shipping_method
      shipping_method.strip.split(' ')[0]
    else
      ''
    end
  end

  def shipped_at
    if transactions && transactions.last && transactions.last.shipped_at
      transactions.last.shipped_at
    else
      created_at
    end
  end

  def name
    "#{addresses.billing_address.first_name} #{addresses.billing_address.last_name}"
  end

end