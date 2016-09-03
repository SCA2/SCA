class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  # line_item has database foreign key constraint
  has_many :line_items, inverse_of: :product

  validates :model, :model_sort_order, presence: true
  validates :category, :category_sort_order, presence: true
  validates :short_description, :long_description, :image_1, presence: true 

  validates :model_sort_order, :category_sort_order, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  validates :model_sort_order, uniqueness: { scope: :model }

  def self.categories
    Product.select(:category).distinct.order(:category)
  end

  def self.get_category_sort_order(category)
    Product.where(category: category).first.category_sort_order
  end

  def self.set_category_sort_order(category, order)
    Product.where(category: category).update_all(category_sort_order: order)
  end

  def self.delete_products_without_options
    products = Product.includes(:options).where(options: {product_id: nil})
    Product.destroy(products) if products.length > 0
  end

  def to_param
    model.upcase
  end

  def bom_count
    @bom_count ||= get_bom_count
    @bom_count ? @bom_count : 0
  end

  def common_stock_count
    @common_stock_count ||= get_common_stock_count
    @common_stock_count ? @common_stock_count : 0
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

  def get_common_stock_count
    items = common_stock_items
    items = items.group_by {|i| i.component_id}
    items = items.select {|k,v| v.length == bom_count}
    items.map {|k,v| v[0].component.stock / v[0].quantity }.min
  end
end
