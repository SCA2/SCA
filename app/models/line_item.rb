class LineItem < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :line_items
  belongs_to :option, inverse_of: :line_items
  belongs_to :cart, inverse_of: :line_items
  
  validates :cart, :product, :option, presence: true
  
  def extended_price
    option.price * quantity
  end
  
  def extended_weight
    product.shipping_weight * quantity
  end

end
