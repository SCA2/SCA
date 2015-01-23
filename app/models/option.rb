class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  
  has_many :line_items, inverse_of: :options
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :description, :upc, :price, :discount, :sort_order,
            :assembled_stock, :partial_stock, :component_stock,
            :shipping_length, :shipping_width, :shipping_height, :shipping_weight, presence: true

  validates :shipping_length, numericality: { only_integer: true, greater_than: 0, less_than: 25 }
  validates :shipping_width, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
  validates :shipping_height, numericality: { only_integer: true, greater_than: 0, less_than: 7 }

  
  after_initialize :init

  REORDER_LIMIT = 25
  
  def init
    self.price ||= 0
    self.discount ||= 0
    self.assembled_stock ||= 0
    self.partial_stock ||= 0
    self.component_stock ||= 0
  end

  def price_in_cents
    self.price * 100
  end
  
  def shipping_volume
    self.shipping_length * self.shipping_width * self.shipping_height
  end

  def stock_message
    if assembled_stock > 0
      "#{assembled_stock} can ship today"
    elsif partial_stock > 0
      "#{partial_stock} can ship in 3 to 5 days"
    elsif component_stock > 0
      "#{component_stock} can ship in 1 to 2 weeks"
    else
      "Please email for lead time"
    end
  end
  
  def subtract_stock(quantity)
    self.assembled_stock -= quantity
    if self.assembled_stock < 0
      self.partial_stock += self.assembled_stock
      self.assembled_stock = 0
    end
    if self.partial_stock < 0
      self.component_stock += self.partial_stock
      self.partial_stock = 0
    end
    self.save
  end

  def reorder?
    self.component_stock < REORDER_LIMIT
  end

end
