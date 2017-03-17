class Product < ActiveRecord::Base

  belongs_to :product_category, inverse_of: :products

  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  # line_item has database foreign key constraint
  has_many :line_items, inverse_of: :product

  # validates :product_category, presence: true
  validates :model, :model_sort_order, presence: true
  validates :short_description, :long_description, :image_1, presence: true 

  validates :model_sort_order, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  validates :model_sort_order, uniqueness: { scope: :model }

  def self.update_product_category
    Product.all.each do |p|
      c = ProductCategory.find_by(name: p.category)
      p.update(product_category: c)
    end
  end

  def self.delete_products_without_options
    products = Product.includes(:options).where(options: {product_id: nil})
    Product.destroy(products) if products.length > 0
  end

  def first_in_category?
    Product.joins(:product_category).
    where("product_categories.id=?", product_category.id).
    order(:model_sort_order).first == self
  end

  def category
    return "Uncategorized" unless product_category
    product_category.name
  end

  def to_param
    model.upcase
  end

  def bom_count
    @bom_count ||= get_bom_count
    @bom_count ? @bom_count : 0
  end

  def common_stock
    @common_stock ||= get_common_stock
    @common_stock ? @common_stock : 0
  end

  def common_stock_items
    items = BomItem.includes(:component, bom: [option: :product])
    items.where(products: {model: model})
  end

private

  def get_bom_count
    boms = Bom.includes(:bom_items, [option: :product])
    boms.where(products: {model: model}).distinct.count
  end

  def get_common_stock
    items = common_stock_items
    items = items.group_by {|i| i.component_id}
    items = items.select {|k,v| v.length == bom_count}
    items.map {|k,v| v[0].component.stock / v[0].quantity }.min
  end
end
