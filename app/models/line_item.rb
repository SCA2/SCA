class LineItem < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :line_items
  belongs_to :cart, inverse_of: :line_items
  
  validates :product, :cart, presence: true
  
  def extended_price
    product.price * quantity
  end
end
