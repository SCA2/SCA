class Cart < ActiveRecord::Base
  
  has_many :line_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :line_items
  
  def add_product(product, option)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item = line_items.find_by(option_id: option.id)
      if current_item
        current_item.quantity += 1
      else
        current_item = line_items.build(product_id: product.id)
        current_item.option = option
      end
    else
      current_item = line_items.build(product_id: product.id)
      current_item.option = option
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