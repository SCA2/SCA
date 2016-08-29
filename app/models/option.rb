class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  has_many :line_items, inverse_of: :option # enforced by pg foreign key constraint
  has_one :bom, inverse_of: :option, dependent: :destroy

  default_scope -> { order('sort_order ASC') }
  
  delegate :product_stock_count, to: :product, prefix: false

  attr_accessor :kits_to_make, :partials_to_make, :assembled_to_make

  validates :kits_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: Proc.new {|a| a.product_stock_count }
  }, if: Proc.new {|a| a.is_a_kit? }
  
  validates :partials_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: Proc.new {|a| a.product_stock_count }
  }, if: Proc.new {|a| !a.is_a_kit? }
  
  validates :assembled_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: Proc.new {|a| a.min_stock }
  }, if: Proc.new {|a| !a.is_a_kit? }
  
  validates :product_id, :model, :description, :upc, presence: true
  validates :price, :discount, :sort_order, presence: true
  validates :assembled_stock, :partial_stock, :kit_stock, presence: true
  validates :shipping_length, :shipping_width, :shipping_height, :shipping_weight, presence: true

  validates_inclusion_of :active, in: [true, false]

  validates :shipping_length, numericality: { only_integer: true, greater_than: 0, less_than: 25 }
  validates :shipping_width, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
  validates :shipping_height, numericality: { only_integer: true, greater_than: 0, less_than: 7 }


  REORDER_LIMIT = 25
  
  def price_in_cents
    self.price * 100
  end

  def discount_in_cents
    self.discount * 100
  end
  
  def shipping_volume
    self.shipping_length * self.shipping_width * self.shipping_height
  end

  def stock_message
    if is_a_kit?
      if kit_stock > 0
        "#{kit_stock} can ship today"
      elsif product_stock_count > 0
        "#{product_stock_count} can ship in 3 to 5 days"
      else
        "Please email for lead time"
      end
    else
      if assembled_stock > 0
        "#{assembled_stock} can ship today"
      elsif partial_stock > 0
        "#{partial_stock} can ship in 3 to 5 days"
      elsif kit_stock > 0
        "#{kit_stock} can ship in 1 to 2 weeks"
      elsif product_stock_count > 0
        "#{product_stock_count} can ship in 1 to 2 weeks"
      else
        "Please email for lead time"
      end
    end
  end
  
  def subtract_stock(quantity)
    if is_a_kit?
      self.kit_stock -= quantity
      if self.kit_stock < 0
        bom.subtract_stock(-self.kit_stock)
        self.kit_stock = 0
      end
    else
      self.assembled_stock -= quantity
      if self.assembled_stock < 0
        self.partial_stock += self.assembled_stock
        self.assembled_stock = 0
      end
      if self.partial_stock < 0
        self.kit_stock += self.partial_stock
        self.partial_stock = 0
      end
      if self.kit_stock < 0
        bom.subtract_stock(-self.kit_stock)
        self.kit_stock = 0
      end
    end
    save!
  end

  def make_kits(n = 0)
    return if !is_a_kit?
    return if (n = n.to_i) > product_stock_count
    bom.subtract_stock(product_stock_items, n)
    self.kit_stock += n
    save(validate: false)
  end

  def make_partials(n = 0)
    return if is_a_kit?
    return if (n = n.to_i) > product_stock_count
    bom.subtract_stock(product_stock_items, n)
    self.partial_stock += n
    save(validate: false)
  end

  def make_assembled(n = 0)
    return if is_a_kit?
    return if (n = n.to_i) > min_stock
    bom.subtract_stock(option_stock_items, n)
    self.assembled_stock += n
    self.partial_stock -= n
    save(validate: false)
  end

  def reorder?
    product_stock_count < REORDER_LIMIT
  end

  def is_a_kit?
    model.include?('KF')
  end

  def active?
    self.active
  end

  def min_stock
    option_stock_count < partial_stock ? option_stock_count : partial_stock
  end

  def option_stock_count
    @option_stock_count ||= get_option_stock_count
  end

  def option_stock_items
    @option_stock_items ||= get_option_stock_items
  end

  def product_stock_items
    bom.bom_items - option_stock_items
  end

private

  def get_option_stock_count
    items = option_stock_items
    items.map {|i| i.component.stock / i.quantity }.min
  end

  def get_option_stock_items
    items = BomItem.includes(:component, bom: [option: :product])
    items = items.where(products: {model: product.model})
    items = items.group_by {|i| i.component_id}
    items = items.reject {|k,v| v.length == product.bom_count}
    items = items.flat_map {|k,v| v}
    items.select {|i| i.bom_id == bom.id}
  end
end

