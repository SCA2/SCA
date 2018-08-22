class Cart < ApplicationRecord
  
  has_one :order, inverse_of: :cart
  has_many :line_items, dependent: :destroy, inverse_of: :cart
  accepts_nested_attributes_for :line_items, allow_destroy: true

  scope :old, -> { where("carts.created_at < ?", 1.week.ago) }
  scope :nil_purchased_at, -> { where(purchased_at: nil) }
  scope :null_order, -> { joins("LEFT OUTER JOIN orders ON carts.id = orders.cart_id").where("orders.cart_id is null") }
  scope :abandoned, -> { old.nil_purchased_at.null_order }
  scope :invoices, -> { where.not(invoice_sent_at: nil) }
  scope :invoices_pending, -> { invoices.where(purchased_at: nil) }
  scope :invoices_paid, -> { invoices.where.not(purchased_at: nil) }
  
  def add_item(line_item_params)
    current_item = line_items.find_by(line_item_params)
    if current_item
      current_item.quantity += 1
      return current_item
    end
    line_items.build(line_item_params)
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

  def find_options_in_cart
    line_items.includes(:option)
  end

  def find_in_cart(option_lines, product, option)
    option_lines.where(itemizable_id: Option.where(product_id: Product.where(model: product)), options: { model: option }).references(:options)
  end

  def discount_amount(line_items, combos)
    combos * line_items.first.discount_in_cents
  end

  def combo_discount(a_product, a_option, b_product, b_option)
    combo_discount = 0
    option_lines = find_options_in_cart

    return 0 if option_lines.empty?

    a_lines = find_in_cart(option_lines, a_product, a_option)
    if a_lines.any?
      a_quantity = a_lines.to_a.sum { |a| a.quantity }
      b_lines = find_in_cart(option_lines, b_product, b_option)
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
    line_items.sum(&:extended_price) - discount
  end

  def total_volume
    line_items.sum(&:shipping_volume)
  end
  
  def min_dimension
    line_items.flat_map { |i| [i.shipping_length, i.shipping_width, i.shipping_height] }.min
  end
  
  def max_dimension
    line_items.flat_map { |i| [i.shipping_length, i.shipping_width, i.shipping_height] }.max
  end
  
  def total_items
    line_items.sum(&:quantity)
  end

  def line_items_empty?
    line_items.empty?
  end
  
  def weight
    line_items.sum(&:extended_weight) * 16
  end

  def intangible?
    max_dimension == 0 && weight == 0
  end
  
  def inventory
    line_items.each do |item|
      calculator = InventoryCalculator.new(item: item)
      calculator.subtract_stock
      calculator.save_inventory
    end
  end

  def purchased?
    purchased_at && purchased_at < Time.zone.now
  end

  def self.destroy_abandoned
    abandoned.destroy_all
  end

  def send_invoice(customer: nil)
    return unless customer
    self.update(
      invoice_name: customer.name,
      invoice_email: customer.email,
      invoice_token: create_invoice_token,
      invoice_sent_at: Time.now
    )
    UserMailer.invoice(invoice: self, customer: customer).deliver_now
  end

private

  def create_invoice_token
    TokenGenerator.new(model_name: self, token_name: 'invoice_token').new_encrypted_token
  end

end
