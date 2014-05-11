class Cart < ActiveRecord::Base
  
  has_one :order, inverse_of: :cart
  has_many :line_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  def add_product(product, option)
    current_item = line_items.find_by(product_id: product.id)
    if current_item
      current_item = line_items.find_by(option_id: option.id)
      if current_item
        current_item.quantity += 1
        return current_item
      end
    end
    current_item = line_items.build(product_id: product.id)
    current_item.option = option
    current_item
  end
  
  def discount
    subpanelable = ['A12', 'C84', 'J99', 'N72', 'T15', 'B16', 'D11']
    comboable = ['A12', 'C84', 'J99', 'N72', 'T15']
    opampable = ['A12', 'J99']
    a12opamps = ['SC10', 'SC25']
    j99opamps = ['SC99']

    total_discount = 0    
    #check combos
    total_discount += combo_discount('A12', a12opamps, 'KA')      
    total_discount += combo_discount('J99', j99opamps, 'KA')      
    total_discount += combo_discount(comboable, 'CH02', '-CH')      
    total_discount += combo_discount(comboable, 'PC01', '-CH')      

    #check for subpanel combos
    line_items.each do |line_item|
      model = line_item.product.model
      if subpanelable.include? model
        total_discount += combo_discount(model, 'CH02', '-SP-' + model)      
      end
    end
    total_discount
  end
  
  def combo_discount(a_product, b_product, b_option)
    a_lines = line_items.joins(:product).where(products: { model: a_product })
    if a_lines.any?
      a_count = a_lines.to_a.sum { |a| a.quantity }
      b_lines = line_items.joins(:product, :option).where(products: { model: b_product }, options: { model: b_option })
      if b_lines.any?
        b_count = b_lines.to_a.sum { |b| b.quantity }
        combo = [a_count, b_count].min
        discount = b_lines.first.option.discount
        return combo_discount = combo * discount        
      end
    end
    combo_discount = 0              
  end

  def subtotal
    line_items.to_a.sum { |item| item.extended_price } - discount
  end
  
  def total_volume
    line_items.to_a.sum { |item| item.quantity * item.option.shipping_volume }
  end
  
  def max_dimension
    a = line_items.to_a.sort { |item| item.option.shipping_length }
    a.last.option.shipping_length
  end
  
  def total_items
    line_items.to_a.sum { |item| item.quantity }
  end
  
  def weight
    line_items.to_a.sum { |item| item.extended_weight * 16 }
  end
  
  def inventory
    line_items.each do |item|
      logger.debug "item.quantity: " + item.quantity.inspect
      item.option.subtract_stock(item.quantity)
    end
  end

end
