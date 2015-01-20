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
  
  MODULES = %w[A12 C84 J99 N72 T15 B16 D11]
  PREAMPS = %w[A12 C84 J99 N72 T15]
  OPTIONS_1 = %w[B]
  OPTIONS_2 = %w[KF KA KF-2S KF-2L KF-2H KA-2S KA-2L KA-2H]

  def discount
    subpanel_set = %w[A12 A12B C84 J99 J99B N72 T15 B16 D11]
    chassis_set = %w[A12 A12B C84 J99 J99B N72 T15]
    opamp_set = %w[A12 J99]
    a12_opamps = %w[SC10 SC25]
    j99_opamps = %w[SC99]

    total_discount = 0    
    #check combos
    total_discount += combo_discount('A12', a12_opamps, 'KA')
    total_discount += combo_discount(chassis_set, 'CH02', 'KF')      

    #check for subpanel combos
    lines = line_items.includes(:product, :option)
    lines.each do |line_item|
      a_model = b_model = line_item.product.model
      b_model = 'A12' if b_model == 'A12B' 
      b_model = 'J99' if b_model == 'J99B' 
      total_discount += combo_discount(a_model, 'CH02', '-SP-' + b_model)      
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
        combos = [a_count, b_count].min
        discount = b_lines.first.option.discount
        return combo_discount = combos * discount        
      end
    end
    combo_discount = 0              
  end

  def subtotal
    line_items.to_a.sum { |item| item.extended_price } - discount
  end

  def subtotal_in_cents
    line_items.to_a.sum { |item| item.extended_price } * 100 - discount * 100
  end

  def discount_in_cents
    discount * 100
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
      # logger.debug "item.quantity: " + item.quantity.inspect
      item.option.subtract_stock(item.quantity)
    end
  end

  def purchased?
    purchased_at && purchased_at < Time.zone.now
  end

end
