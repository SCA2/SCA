class Cart < ActiveRecord::Base
  
  has_many :line_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :line_items
  
  def add_product(product_id, option_id)
    current_item = line_items.find_by(product_id: product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
#      current_item.product = line_items.build(option_id: option_id)
    end
    current_item
  end
  
  def total_price
    line_items.to_a.sum { |item| item.extended_price }
  end
  
  def total_items
    line_items.to_a.sum { |item| item.quantity }
  end
  
  def total_weight
    line_items.to_a.sum { |item| item.extended_weight }
  end

end
