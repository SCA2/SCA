class Product < ApplicationRecord

  belongs_to :product_category, inverse_of: :products
  belongs_to :display_category,
    class_name: "ProductCategory",
    foreign_key: "display_category_id",
    inverse_of: :displays

  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  validates :model, uniqueness: true
  validates :model, :sort_order, presence: true
  validates :short_description, :long_description, :image_1, presence: true 

  validates :sort_order, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  validates :sort_order, uniqueness: { scope: :model }

  scope :sorted, -> { joins(:display_category).merge(ProductCategory.sorted).order(:sort_order) }
  scope :active, -> { sorted.where(active: true) }

  def model=(val)
    self[:model] = val ? val.upcase : nil
  end

  def self.update_product_category
    Product.all.each do |p|
      c = ProductCategory.find_by(name: p.category)
      p.update(product_category: c)
    end
  end

  def self.delete_products_without_options
    Product.includes(:options).where(options: { product_id: nil }).destroy_all
  end

  def first_in_category?
    Product.joins(:display_category).
    where("product_categories.id=?", display_category.id).
    sorted.first == self
  end

  def active_options
    Option.where(options: {active: true}).
    joins(:product).where(products: {id: id}).
    sorted
  end

  def product_category_name
    return "Uncategorized" unless product_category
    product_category.name
  end

  def to_param
    model.upcase
  end

end
