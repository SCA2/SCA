class Option < ApplicationRecord
  
  belongs_to :product, inverse_of: :options

  # enforced by pg foreign key constraint
  has_many :line_items, as: :itemizable, inverse_of: :option, dependent: :restrict_with_exception
  
  has_one :bom, inverse_of: :option, dependent: :destroy

  delegate :common_stock_items, :common_stock, to: :product
  delegate :partial_stock, :kit_stock, to: :product
  delegate :partial_stock=, :kit_stock=, to: :product

  validates :model, uniqueness: { scope: :product }
  validates :sort_order, uniqueness: { scope: :product }

  validates :shipping_length, :shipping_width, presence: true
  validates :shipping_height, :shipping_weight, presence: true
  validates :model, :description, :upc, presence: true
  validates :price, :discount, :sort_order, presence: true

  validates_inclusion_of :active, in: [true, false]

  validates :shipping_length, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 25
  }

  validates :shipping_width, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 13
  }
  
  validates :shipping_height, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 7
  }

  validates :shipping_weight, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 30
  }

  validates :assembled_stock, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }, if: :is_assembled?

  STOCK_CUTOFF = 12

  def item_model
    product.model + model
  end

  def item_description
    "#{product.category}, #{description}"
  end

  def price_in_cents
    self.price * 100
  end

  def discount_in_cents
    self.discount * 100
  end
  
  def active?
    self.active
  end

  def enabled?
    active? && bom.present?
  end

  def disabled?
    !enabled?
  end

  def is_kit?
    model.include?('KF')
  end

  def is_assembled?
    model.include?('KA')
  end

  def stock_message
    if disabled?
      "Not available at this time"
    elsif is_kit?
      if kit_stock > STOCK_CUTOFF
        "Can ship today"
      elsif kit_stock > 0
        "#{kit_stock} can ship today"
      elsif limiting_stock > STOCK_CUTOFF
        "Can ship in 3 to 5 days"
      elsif limiting_stock > 0
        "#{limiting_stock} can ship in 3 to 5 days"
      else
        "Please <a href='mailto:sales@seventhcircleaudio.com'>email</a> for lead time".html_safe
      end
    elsif is_assembled?
      if assembled_stock > STOCK_CUTOFF
        "Can ship today"
      elsif assembled_stock > 0
        "#{assembled_stock} can ship today"
      elsif partial_stock > STOCK_CUTOFF
        "Can ship in 3 to 5 days"
      elsif partial_stock > 0
        "#{partial_stock} can ship in 3 to 5 days"
      elsif limiting_stock > 0
        "#{limiting_stock} can ship in 1 to 2 weeks"
      else
        "Please <a href='mailto:sales@seventhcircleaudio.com'>email</a> for lead time".html_safe
      end
    else
      if limiting_stock > STOCK_CUTOFF
        "Can ship in 3 to 5 days"
      elsif limiting_stock > 0
        "#{limiting_stock} can ship in 3 to 5 days"
      else
        "Please <a href='mailto:sales@seventhcircleaudio.com'>email</a> for lead time".html_safe
      end
    end
  end

  def limiting_stock
    return 0 unless bom
    if common_stock_items.present? && option_stock_items.present?
      [common_stock, option_stock].min
    elsif common_stock_items.present?
      common_stock
    else
      option_stock
    end
  end

  def option_stock
    return 0 unless bom
    @option_stock ||= get_option_stock
    @option_stock ? @option_stock : 0
  end

  def option_stock_items
    return [] unless bom
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

