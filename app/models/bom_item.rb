class BomItem < ActiveRecord::Base
  belongs_to :bom, inverse_of: :bom_items

  default_scope -> { order :reference }
end