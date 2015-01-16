class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  
  has_many :line_items, inverse_of: :options
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :description, :upc, :price, :discount, :sort_order,
            :assembled_stock, :partial_stock, :kit_stock, :part_stock,
            :shipping_length, :shipping_width, :shipping_height, :shipping_weight, presence: true

  validates :shipping_length, numericality: { only_integer: true, greater_than: 0, less_than: 25 }
  validates :shipping_width, numericality: { only_integer: true, greater_than: 0, less_than: 13 }
  validates :shipping_height, numericality: { only_integer: true, greater_than: 0, less_than: 7 }

  
  after_initialize :init

  REORDER_LIMIT = 25
  
  def init
    self.discount ||= 0
  end

  def price_in_cents
    price * 100
  end
  
  def shipping_volume
    self.shipping_length * self.shipping_width * self.shipping_height
  end
  
  def subtract_stock(quantity)
    self.assembled_stock -= quantity
    if self.assembled_stock < 0
      self.kit_stock += self.assembled_stock
      self.assembled_stock = 0
    end
    if self.kit_stock < 0
      self.part_stock += self.kit_stock
      self.kit_stock = 0
    end
    if self.part_stock < REORDER_LIMIT
      #send email notification
    end
    self.save
  end
  
  def sell_kit(quantity)
    self.kit_stock -= quantity
    if self.kit_stock < 0
      self.part_stock += self.kit_stock
      self.kit_stock = 0
    end
    if self.part_stock < REORDER_LIMIT
      #send email notification
    end
    self.save
  end

  def sell_assembled(quantity)
    self.assembled_stock -= quantity
    if self.assembled_stock < 0
      self.partial_stock += self.assembled_stock
      self.assembled_stock = 0
    end
    if self.partial_stock < 0
      self.part_stock += self.partial_stock
      self.partial_stock = 0
    end
    if self.part_stock < REORDER_LIMIT
      #send email notification
    end
    self.save
  end

end
