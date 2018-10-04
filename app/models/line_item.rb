class LineItem < ApplicationRecord
  belongs_to :cart, inverse_of: :line_items
  belongs_to :component, inverse_of: :line_items

  belongs_to :option, foreign_type: 'Option', foreign_key: 'option_id'

  validates :cart, :component, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  
  delegate :item_model, :item_description, to: :component
  delegate :full_price_in_cents, :discount_price_in_cents, to: :component
  delegate :shipping_length, :shipping_width, to: :component
  delegate :shipping_height, :shipping_weight, to: :component
  delegate :pick, :pick!, to: :component

  def item
    component
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
