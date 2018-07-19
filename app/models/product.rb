class Product < ApplicationRecord

  belongs_to :product_category, inverse_of: :products

  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  # line_item has database foreign key constraint
  has_many :line_items, inverse_of: :product

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
    Product.includes(:options).where(options: { product_id: nil }).destroy_all
  end

  def first_in_category?
    Product.joins(:product_category).
    where("product_categories.id=?", product_category.id).
    order(:model_sort_order).first == self
  end

  def active_options
    Option.where(options: {active: true}).
    joins(:product).where(products: {id: id}).
    order(:sort_order)
  end

  def category
    return "Uncategorized" unless product_category
    product_category.name
  end

  def to_param
    model.upcase
  end

  def common_stock
    return 0 unless bom
    @common_stock ||= get_common_stock
    @common_stock ? @common_stock : 0
  end

  def common_stock_items
    return [] unless bom
    @common_stock_items ||= get_common_stock_items
  end

private

  def get_common_stock_items
    BomItem.find_by_sql("
      SELECT * FROM bom_items
      WHERE bom_items.component_id IN (
        SELECT components.id FROM bom_items
        JOIN components ON bom_items.component_id = components.id
        JOIN boms ON bom_items.bom_id = boms.id
        JOIN options ON boms.option_id = options.id
        JOIN products ON options.product_id = products.id
        WHERE options.product_id = #{self.id}
        GROUP BY components.id
        HAVING COUNT(bom_items.id) = #{options.count}
      ) AND bom_items.bom_id IN (
        SELECT boms.id FROM bom_items
        JOIN components ON bom_items.component_id = components.id
        JOIN boms ON bom_items.bom_id = boms.id
        JOIN options ON boms.option_id = options.id
        JOIN products ON options.product_id = products.id
        WHERE options.product_id = #{self.id}
      )
    ")
  end

  def get_common_stock
    items = common_stock_items
    items = items.reject {|i| i.quantity.zero? }
    items.map {|i| i.component.stock / i.quantity }.min
  end
end
