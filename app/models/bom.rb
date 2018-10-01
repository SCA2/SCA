class Bom < ApplicationRecord
  belongs_to :component, inverse_of: :bom
  has_many :bom_items, inverse_of: :bom, dependent: :destroy

  validates :component, presence: true
  validates :component, uniqueness: true

  accepts_nested_attributes_for :bom_items, allow_destroy: true

  scope :sorted, -> { joins(:component).order('components.mfr_part_number') }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def product
    option.product if option
  end

  def product_name
    product.model + option.model if product && option
  end

  def component_name
    component.mfr_part_number
  end

  def lines
    bom_items.count
  end

  def stock
    # return nil if items.any? { |i| i.component.bom_stock.nil? || i.quantity == 0 }
    child_items.map { |i| i.component.recursive_stock / i.quantity }.min
  end

  def lead_time
    items.map { |i| i.component.bom_lead_time }.max
  end

  def subtract_stock(items, quantity)
    self.transaction do
      items.each do |i|
        next unless i.bom == self
        i.component.pick!(quantity: quantity * i.quantity)
      end
    end
  end

  def pick(quantity: 0)
    subtract_stock(items, quantity)
  end

  def add_stock(n)
    return if n < 0
    self.transaction do
      items.each do |i|
        new_stock = i.component.stock + n * i.quantity
        i.component.update!(stock: new_stock)
      end
    end
  end

  def child_items
    items.flat_map do |item|
      if item.component.bom
        [item] + item.component.child_items
      else
        [item]
      end
    end
  end

private

  def items
    @items ||= bom_items.includes(:component)
  end

end