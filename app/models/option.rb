class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  has_many :line_items, inverse_of: :option # enforced by pg foreign key constraint
  has_one :bom, inverse_of: :option, dependent: :destroy

  default_scope -> { order('sort_order ASC') }
  
  delegate :common_stock_count, to: :product, prefix: false
  delegate :partial_stock, :kit_stock, to: :product, prefix: false

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

  def stock_message
    if is_a_kit?
      if kit_stock > 0
        "#{kit_stock} can ship today"
      elsif common_stock_count > 0
        "#{common_stock_count} can ship in 3 to 5 days"
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
      elsif common_stock_count > 0
        "#{common_stock_count} can ship in 1 to 2 weeks"
      else
        "Please email for lead time"
      end
    end
  end
end

