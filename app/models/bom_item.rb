class BomItem < ApplicationRecord
  belongs_to :bom, inverse_of: :bom_items
  belongs_to :component, inverse_of: :bom_items
  
  validates :component, presence: true
  validates :component, uniqueness: { scope: :bom }

  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  validates :reference, format: {
    with: /\A[a-z]+\d+(\s+\(optional\))?((,(| )|(\p{Pd}|( \p{Pd} )))[a-z]+\d+(\s+\(Optional\))?)*\z/i
  }, if: Proc.new { |a| a.reference.present? }

  # scope :by_reference, -> { order(reference: :asc) }
  default_scope { order(reference: :asc) }
  # scope :by_mfr_part_number, -> { joins(:component).order('components.mfr_part_number') }
  default_scope { joins(:component).order('components.mfr_part_number') }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def stock
    return 0 unless component.stocked? && quantity > 0
    component.recursive_stock / quantity
  end

  def pick!(quantity: 0)
    component.pick!(quantity: self.quantity * quantity) if component.stocked?
  end

  def restock!(quantity: 0)
    new_stock = component.stock + self.quantity * quantity
    component.update!(stock: new_stock)
  end
end