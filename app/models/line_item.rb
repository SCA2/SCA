class LineItem < ActiveRecord::Base
  belongs_to :product, inverse_of: :line_items
  belongs_to :option, inverse_of: :line_items
  belongs_to :cart, inverse_of: :line_items
  validates :cart, :product, :option, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  default_scope { order(created_at: :asc) }

  def model
    product.model + option.model
  end

  def category
    product.category
  end

  def description
    option.description
  end

  def price
    option.price_in_cents
  end

  def discount
    option.discount_in_cents
  end

  def shipping_length
    option.shipping_length
  end
  
  def shipping_width
    option.shipping_width
  end
  
  def shipping_height
    option.shipping_height
  end
  
  def shipping_volume
    option.shipping_volume
  end
  
  def shipping_weight
    option.shipping_weight
  end
  
  def extended_price
    option.price_in_cents * quantity
  end

  def extended_weight
    option.shipping_weight * quantity
  end
  
end
