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

  def is_kit?
    model.include?('KF')
  end

  def is_assembled?
    model.include?('KA')
  end

  def stock_message
    if is_kit?
      if kit_stock > 8
        "In stock"
      elsif kit_stock > 0
        "#{kit_stock} can ship today"
      elsif limiting_stock > 0
        "#{limiting_stock} can ship in 3 to 5 days"
      else
        "Please email for lead time"
      end
    else
      if assembled_stock > 8
        "In stock"
      elsif assembled_stock > 0
        "#{assembled_stock} can ship today"
      elsif partial_stock > 0
        "#{partial_stock} can ship in 3 to 5 days"
      elsif limiting_stock > 0
        "#{limiting_stock} can ship in 1 to 2 weeks"
      else
        "Please email for lead time"
      end
    end
  end

  def limiting_stock
    return 0 unless bom
    [common_stock, option_stock].min
  end

  def option_stock
    @option_stock ||= get_option_stock
    @option_stock ? @option_stock : 0
  end

  def option_stock_items
    @option_stock_items ||= get_option_stock_items
    @option_stock_items ? @option_stock_items : 0
  end

private

  def get_option_stock
    if product.options.count == 1
      common_stock
    else
      items = option_stock_items
      items = items.reject { |i| i.quantity.zero? }
      items.map { |i| i.component.stock / i.quantity }.min
    end
  end

  def get_option_stock_items
    bom.bom_items - common_stock_items
  end  
end

