class BomItem < ActiveRecord::Base
  belongs_to :bom, inverse_of: :bom_items
  belongs_to :component, inverse_of: :bom_items
  
  validates :component, uniqueness: { scope: :bom }
  validates :quantity, :reference, :component, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :reference, format: { with: /\A[a-z]+\d+((,(| )|(-|( - )))[a-z]+\d+)*\z/i }

  default_scope -> { order :reference }
end