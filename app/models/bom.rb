class Bom < ActiveRecord::Base
  belongs_to :product, inverse_of: :boms
  has_many :bom_items, inverse_of: :bom, dependent: :destroy

  default_scope -> { order :revision }
end