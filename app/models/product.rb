class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  # line_item has database foreign key constraint
  has_many :line_items, inverse_of: :product

  validates :model, :model_sort_order, :category, :category_sort_order,
            :short_description, :long_description, :image_1, presence: true 
            
  def to_param
    model.upcase
  end

  def product_stock_count
    @product_stock_count ||= get_product_stock_count
  end

  def bom_count
    @bom_count ||= get_bom_count
  end

private

  def get_bom_count
    boms = Bom.includes(:bom_items, [option: :product])
    boms.where(products: {model: model}).distinct.count
  end

  def get_product_stock_count
    items = BomItem.includes(:component, bom: [option: :product])
    items = items.where(products: {model: model})
    items = items.group_by {|i| i.component_id}
    items = items.select {|k,v| v.length == bom_count}
    items.map {|k,v| v[0].component.stock / v[0].quantity }.min
  end
end
