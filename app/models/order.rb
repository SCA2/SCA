class Order < ActiveRecord::Base

  belongs_to :cart, inverse_of: :order
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :transactions

  accepts_nested_attributes_for :addresses

  delegate :purchased?, :purchased_at, :subtotal, :min_dimension, :max_dimension, :total_volume, :weight, to: :cart

  scope :checked_out, -> do
    where("shipping_method IS NOT NULL AND confirmed = true AND (stripe_token IS NOT NULL OR express_token IS NOT NULL)").
    joins(:cart).where.not(carts: {purchased_at: nil}).
    joins(:addresses).where(addresses: {address_type: 'billing'}).
    joins(:transactions).preload(:transactions).
    select('orders.*', 'addresses.first_name as first_name', 'addresses.last_name as last_name', 'transactions.*', 'transactions.created_at as received_at', 'transactions.shipped_at as shipped_at', 'transactions.amount as amount')
  end

  scope :successful, -> do
    checked_out.where(transactions: {success: true}).
    order(created_at: :asc).distinct
  end

  scope :failed, -> do
    checked_out.where(transactions: {success: false}).
    order(created_at: :asc).distinct
  end

  scope :pending, -> do
    successful.where(transactions: {shipped_at: nil, tracking_number: nil}).
    order(created_at: :asc).distinct
  end

  scope :shipped, -> do
    successful.where.not(transactions:{shipped_at: nil, tracking_number: nil}).
    order(created_at: :asc)
  end

  scope :abandoned, -> do
    where(stripe_token: nil, express_token: nil).
    where('orders.created_at < ?', 1.month.ago).
    joins(:cart).where(carts: {purchased_at: nil}).
    order('orders.created_at asc')
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

  def ship_date
    if transactions && transactions.last && transactions.last.shipped_at
      transactions.last.shipped_at.to_date.to_formatted_s(:db)
    else
      'Not Shipped'
    end
  end

  def tracking_number
    if transactions && transactions.last && transactions.last.tracking_number
      transactions.last.tracking_number
    else
      'Not Shipped'
    end
  end

  def name
    if billing_address.present?
      "#{addresses.billing_address.first_name} #{addresses.billing_address.last_name}"
    else
      "Missing Name"
    end
  end

  def token
    return stripe_token if stripe_token
    return express_token if express_token
  end

end