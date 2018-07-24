class LineItem < ApplicationRecord
  belongs_to :cart, inverse_of: :line_items
  belongs_to :option, inverse_of: :line_items

  validates :cart, :option, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  delegate :product, :category, :description, to: :option
  delegate :price_in_cents, :discount_in_cents, to: :option
  delegate :shipping_volume, :shipping_weight, to: :option

  def model
    option.sku
  end

  def extended_price
    price_in_cents * quantity
  end

  def extended_weight
    shipping_weight * quantity
  end
  
end
