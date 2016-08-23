class Bom < ActiveRecord::Base
  belongs_to :option, inverse_of: :bom
  has_many :bom_items, inverse_of: :bom, dependent: :destroy

  validates :option, :revision, :pdf, presence: true
  validates :option, uniqueness: true

  accepts_nested_attributes_for :bom_items, allow_destroy: true

  default_scope -> { order :revision }

  def self.permitted_attributes
    self.column_names - ['id', 'created_at', 'updated_at']
  end

  def product
    option.product if option
  end

  def lines
    bom_items.count
  end

  def stock
    items = Bom.includes(bom_items: [:component]).find(id).bom_items
    items.map {|i| i.component.stock / i.quantity}.min
  end
end