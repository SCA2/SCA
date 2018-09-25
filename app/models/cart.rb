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
    preamps = %w[A12 C84 J99 N72 T15 A12B J99B]
    ch02_options = %w[KF KA-1 KA-2 KA-3 KA-4 KA-5 KA-6 KA-7 KA-8]
    opamps = %w[SC10KA SC25KA]

    total_discount = 0    

    total_discount += combo_discount("A12K%", opamps)

    ch02_options.each do |option|
      if option == 'KF'
        preamps_KF = preamps.map {|p| "#{p}KF%"}
        total_discount += combo_discount(preamps_KF, "CH02#{option}")
      else
        preamps_KA = preamps.map {|p| "#{p}KA%"}
        min_quantity = option.split('').last.to_i
        total_discount += combo_discount(preamps_KA, "CH02#{option}") { |a, b| [a, b * min_quantity].min / min_quantity }
      end
    end

    subpanels.each do |subpanel|
      a_products = ["#{subpanel}%", "#{subpanel}B%"] 
      total_discount += combo_discount(a_products, "CH02-SP-#{subpanel}")      
    end

    total_discount

  end

  def discount_amount(line_items, combos)
    line_items.limit(combos).sum { |item| item.full_price_in_cents - item.discount_price_in_cents }
  end

  def combo_discount(a_products, b_products)
    a_lines = line_items.joins(:component).where("mfr_part_number LIKE ANY (array[?])", a_products)
    return 0 unless a_lines.any?
    a_quantity = a_lines.sum(&:quantity)
    b_lines = line_items.joins(:component).where("mfr_part_number LIKE ANY (array[?])", b_products)
    return 0 unless b_lines.any?
    b_quantity = b_lines.sum(&:quantity)
    if block_given?
      combos = yield(a_quantity, b_quantity)
    else
      combos = [a_quantity, b_quantity].min
    end
    discount_amount(a_lines, combos) + discount_amount(b_lines, combos)        
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

  def inventory
    line_items.each { |item| item.pick(quantity: item.quantity) }
  end

  def intangible?
    max_dimension == 0 && weight == 0
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
