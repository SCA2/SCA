class ProductCategory < ApplicationRecord

  has_many :products, inverse_of: :product_category, dependent: :restrict_with_error
  has_many :displays,
    class_name: "Product",
    foreign_key: "display_category_id",
    inverse_of: :display_category,
    dependent: :restrict_with_error

  validates :name, :sort_order, presence: :true, uniqueness: :true
  validates :sort_order, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 101
  }

  scope :sorted, -> { order :sort_order }

  def active_count
    displays.where(active: true).count || 0
  end

end
