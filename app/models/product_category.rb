class ProductCategory < ApplicationRecord

  has_many :products, inverse_of: :product_category, dependent: :restrict_with_error

  validates :name, :sort_order, presence: :true, uniqueness: :true
  validates :sort_order, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 101
  }

end
