class SizeWeightPriceTag < ApplicationRecord
  belongs_to :component, inverse_of: :size_weight_price_tag
  has_many :line_items, through: :component, dependent: :restrict_with_exception
  has_many :options, through: :component, dependent: :restrict_with_exception

  validates :upc, :full_price, :discount_price, presence: true
  validates :shipping_length, :shipping_width, presence: true
  validates :shipping_height, :shipping_weight, presence: true

  validates :shipping_length, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 25
  }

  validates :shipping_width, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 13
  }
  
  validates :shipping_height, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 7
  }

  validates :shipping_weight, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than: 30
  }

  def full_price_in_cents
    full_price * 100
  end

  def discount_price_in_cents
    discount_price * 100
  end

end