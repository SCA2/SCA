class LineItem < ApplicationRecord
  belongs_to :cart, inverse_of: :line_items
  belongs_to :itemizable, polymorphic: true

  belongs_to :option, foreign_type: 'Option', foreign_key: 'itemizable_id'
  belongs_to :component, foreign_type: 'Component', foreign_key: 'itemizable_id', inverse_of: :line_items

  validates :cart, :itemizable, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  delegate :item_model, :item_description, to: :itemizable
  delegate :full_price_in_cents, :discount_price_in_cents, to: :itemizable
  delegate :shipping_length, :shipping_width, to: :itemizable
  delegate :shipping_height, :shipping_weight, to: :itemizable
  delegate :pick, :pick!, to: :itemizable

  def item
    itemizable
  end

  def extended_price
    full_price_in_cents * quantity
  end

  def extended_weight
    shipping_weight * quantity
  end

  def shipping_volume
    shipping_length * shipping_width * shipping_height * quantity
  end
  
end
