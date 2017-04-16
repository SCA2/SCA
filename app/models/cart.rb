class Cart < ActiveRecord::Base
  
  has_one :order, dependent: :destroy, inverse_of: :cart
  has_many :line_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :line_items, allow_destroy: true

  scope :old, -> { where("carts.created_at < ?", 1.week.ago) }
  scope :nil_purchased_at, -> { where(purchased_at: nil) }
  scope :null_order, -> { joins("LEFT OUTER JOIN orders ON carts.id = orders.cart_id").where("orders.cart_id is null") }
  scope :abandoned, -> { old.nil_purchased_at.null_order }
  
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
    subpanels = %w[A12 C84 J99 N72 T15 B16 D11]
    preamps_KF = %w[A12 C84 J99 N72 T15]
    preamps_KFKA = preamps_KF + %w[A12B J99B]
    ch02_options = %w[KF KA-1 KA-2 KA-3 KA-4 KA-5 KA-6 KA-7 KA-8]
    module_KF_options = %w[KF KF-2S KF-2L KF-2H]
    module_KA_options = %w[KA KA-2S KA-2L KA-2H]
    module_options = module_KA_options + module_KF_options
    a12_opamps = %w[SC10 SC25]

    total_discount = 0    

    total_discount += combo_discount('A12', module_options, a12_opamps, 'KA')

    ch02_options.each do |option|
      if option == 'KF'
        min_quantity = 1
        total_discount += combo_discount(preamps_KFKA, module_options, 'CH02', option) { |a, b| [a, b * min_quantity].min / min_quantity }
      else
        min_quantity = option.split('').last.to_i
        total_discount += combo_discount(preamps_KFKA, module_KA_options, 'CH02', option) { |a, b| [a, b * min_quantity].min / min_quantity }
      end
    end

    subpanels.each do |a_model|
      b_options = '-' + a_model
      a_model = [a_model, a_model + 'B'] 
      total_discount += combo_discount(a_model, module_options, 'CH02-SP', b_options)      
    end

    total_discount

  end

  def find_in_cart(product, option)
    line_items.joins(:product, :option).where(products: { model: product }, options: { model: option })
  end

  def discount_amount(line_items, combos)
    combos * line_items.first.discount
  end

  def combo_discount(a_product, a_option, b_product, b_option)
    combo_discount = 0              
    a_lines = find_in_cart(a_product, a_option)
    if a_lines.any?
      a_quantity = a_lines.to_a.sum { |a| a.quantity }
      b_lines = find_in_cart(b_product, b_option)
      if b_lines.any?
        b_quantity = b_lines.to_a.sum { |b| b.quantity }
        if block_given?
          combos = yield(a_quantity, b_quantity)
        else
          combos = [a_quantity, b_quantity].min
        end
        combo_discount = discount_amount(b_lines, combos)        
      end
    end
    combo_discount
  end

  def subtotal
    line_items.to_a.sum { |item| item.extended_price } - discount
  end

  def total_volume
    line_items.to_a.sum { |item| item.quantity * item.shipping_volume }
  end
  
  def min_dimension
    a = line_items.to_a.sort { |item| item.shipping_height }
    a.first.option.shipping_height
  end
  
  def max_dimension
    a = line_items.to_a.sort { |item| item.shipping_length }
    a.last.option.shipping_length
  end
  
  def total_items
    line_items.to_a.sum { |item| item.quantity }
  end

  def line_items_empty?
    line_items.empty?
  end
  
  def weight
    line_items.to_a.sum { |item| item.extended_weight * 16 }
  end
  
  def inventory
    line_items.each do |item|
      calculator = InventoryCalculator.new(option: item.option)
      calculator.subtract_stock(quantity: item.quantity)
      calculator.save_inventory
    end
  end

  def purchased?
    purchased_at && purchased_at < Time.zone.now
  end

  def self.destroy_abandoned
    abandoned.destroy_all
  end

end
