class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  
  has_many :line_items, inverse_of: :options
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :description, :price, :sort_order,
            :assembled_stock, :partial_stock, :kit_stock, :part_stock, presence: true
  
  after_initialize :init

  REORDER_LIMIT = 25
  
  def init
    self.discount ||= 0
  end
  
  def subtract_stock(quantity)
    self.finished_stock -= quantity
    if self.finished_stock < 0
      self.kit_stock += self.finished_stock
      self.finished_stock = 0
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
  
  def shipping_volume
    self.shipping_length * self.shipping_width * self.shipping_height
  end
  
end
