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
    items.map { |i| i.stock }.min
  end

  def lead_time
    items.map { |i| i.component.bom_lead_time }.max
  end

  def pick!(quantity: 0)
    return if quantity < 0
    self.transaction do
      items.each { |i| i.pick!(quantity: quantity) }
    end
  end

  def restock!(quantity: 0)
    return if quantity < 0
    self.transaction do
      items.each { |i| i.restock!(quantity: quantity) }
    end
  end

private

  def items
    @items ||= bom_items.includes(:component)
  end

end