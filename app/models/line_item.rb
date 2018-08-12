class LineItem < ApplicationRecord
  belongs_to :cart, inverse_of: :line_items
  belongs_to :itemizable, polymorphic: true

  belongs_to :option, foreign_type: 'Option', foreign_key: 'itemizable_id'

  validates :cart, :itemizable, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  delegate :item_model, :item_description, to: :itemizable
  delegate :price_in_cents, :discount_in_cents, to: :itemizable
  delegate :shipping_length, :shipping_width, to: :itemizable
  delegate :shipping_height, :shipping_weight, to: :itemizable

  def item
    itemizable
  end

  def extended_price
    price_in_cents * quantity
  end

  def extended_weight
    shipping_weight * quantity
  end

  def shipping_volume
    shipping_length * shipping_width * shipping_height * quantity
  end
  
end
