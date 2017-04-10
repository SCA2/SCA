class BomItem < ActiveRecord::Base
  belongs_to :bom, inverse_of: :bom_items
  belongs_to :component, inverse_of: :bom_items
  
  validates :component, uniqueness: { scope: :bom }
  validates :quantity, :component, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: -1 }
  validates :reference, format: {
    with: /\A[a-z]+\d+(\s+\(optional\))?((,(| )|(\p{Pd}|( \p{Pd} )))[a-z]+\d+(\s+\(Optional\))?)*\z/i
  }, if: 'reference.present?'

  scope :by_reference, -> { order(reference: :asc) }
  scope :by_mfr_part_number, -> { joins(:component).order('components.mfr_part_number') }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def stock
    component.stock / quantity
  end
end