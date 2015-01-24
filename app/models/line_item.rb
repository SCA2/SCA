class LineItem < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :line_items
  belongs_to :option, inverse_of: :line_items
  belongs_to :cart, inverse_of: :line_items
  validates :cart, :product, :option, presence: true
  
  default_scope { order('created_at ASC') }

  def product_model
    product.model
  end

  def option_model
    option.model
  end

  def full_model
    product.model + option.model
  end

  def extended_price
    option.price * quantity
  end
  
  def extended_weight
    option.shipping_weight * quantity
  end
  
end
