class Bom < ApplicationRecord
  belongs_to :option, inverse_of: :bom
  belongs_to :component, inverse_of: :bom

  has_many :bom_items, inverse_of: :bom, dependent: :destroy

  validates :option, presence: true
  validates :option, uniqueness: true

  accepts_nested_attributes_for :bom_items, allow_destroy: true

  scope :sorted, -> { joins(option: :product).order('products.model', 'options.model') }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def product
    option.product if option
  end

  def product_name
    product.model + option.model
  end

  def lines
    bom_items.count
  end

  def stock
    stock = items.map { |i| i.quantity.zero? ? nil : i.component.stock / i.quantity }
    stock.reject { |i| i.nil? }.min
  end

  def lead_time
    bom_items.map { |i| i.component.lead_time }.max
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
    # byebug
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

private

  def items
    # @items ||= Bom.includes(bom_items: [:component]).find(self.id).bom_items
    @items ||= bom_items.includes(:component)
  end
end