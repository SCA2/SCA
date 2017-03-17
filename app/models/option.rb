class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  has_many :line_items, inverse_of: :option # enforced by pg foreign key constraint
  has_one :bom, inverse_of: :option, dependent: :destroy

  default_scope -> { order('sort_order ASC') }
  
  delegate :common_stock_items, :common_stock, to: :product
  delegate :partial_stock, :kit_stock, to: :product
  delegate :partial_stock=, :kit_stock=, to: :product

  validates :model, uniqueness: { scope: :product }
  validates :sort_order, uniqueness: { scope: :product }

  def price_in_cents
    self.price * 100
  end

  def discount_in_cents
    self.discount * 100
  end
  
  def shipping_volume
    self.shipping_length * self.shipping_width * self.shipping_height
  end

  def active?
    self.active
  end

  def is_a_kit?
    model.include?('KF')
  end

  def subtract_stock(quantity)
    if is_a_kit?
      product.kit_stock -= quantity
      bom.subtract_stock(option_stock_items, quantity)
      if product.kit_stock < 0
        bom.subtract_stock(common_stock_items, -product.kit_stock)
        product.kit_stock = 0
      end
    else
      self.assembled_stock -= quantity
      bom.subtract_stock(option_stock_items, quantity)
      if self.assembled_stock < 0
        product.partial_stock += self.assembled_stock
        self.assembled_stock = 0
      end
      if product.partial_stock < 0
        bom.subtract_stock(common_stock_items, -product.partial_stock)
        product.partial_stock = 0
      end
    end
  end

  def stock_message
    if is_a_kit?
      if kit_stock > 0
        "#{limiting_stock(kit_stock)} can ship today"
      elsif common_stock > 0
        "#{limiting_stock(common_stock)} can ship in 3 to 5 days"
      else
        "Please email for lead time"
      end
    else
      if assembled_stock > 0
        "#{assembled_stock} can ship today"
      elsif partial_stock > 0
        "#{limiting_stock(partial_stock)} can ship in 3 to 5 days"
      elsif common_stock > 0
        "#{limiting_stock(common_stock)} can ship in 1 to 2 weeks"
      else
        "Please email for lead time"
      end
    end
  end

  def limiting_stock(stock)
    if has_optional_items?
      option_stock < stock ? option_stock : stock
    else
      stock
    end
  end

  def option_stock
    @option_stock ||= get_option_stock
    @option_stock ? @option_stock : 0
  end

  def has_optional_items?
    option_stock_items.count > 0
  end

  def option_stock_items
    @option_stock_items ||= get_option_stock_items
    @option_stock_items ? @option_stock_items : 0
  end

private

  def get_option_stock
    items = option_stock_items
    items.map {|i| i.component.stock / i.quantity }.min
  end

  def get_option_stock_items
    items = product.common_stock_items
    items = items.group_by {|i| i.component_id}
    items = items.reject {|k,v| v.length == product.bom_count}
    items = items.flat_map {|k,v| v}
    items.select {|i| i.bom_id == bom.id}
  end  
end

