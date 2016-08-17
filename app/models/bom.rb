class Bom < ActiveRecord::Base
  belongs_to :product, inverse_of: :boms
  has_many :bom_items, inverse_of: :bom, dependent: :destroy

  validates :product, :revision, :pdf, presence: true

  accepts_nested_attributes_for :bom_items, allow_destroy: true

  default_scope -> { order :revision }

  def lines
    bom_items.count
  end

  def stock
  end
end