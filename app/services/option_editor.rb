class OptionEditor

  include ActiveModel::Model

  delegate :product_id, :model, :description, :upc, to: :option
  delegate :price, :discount, :sort_order, :active, to: :option
  delegate :shipping_length, :shipping_width, to: :option 
  delegate :shipping_height, :shipping_weight, to: :option
  delegate :assembled_stock, :is_a_kit?, to: :option

  delegate :bom_count, :common_stock_items, :common_stock_count, to: :product
  delegate :kit_stock, :partial_stock, to: :product

  attr_accessor :kits_to_make, :partials_to_make, :assembled_to_make
  attr_reader :product, :option, :bom

  REORDER_LIMIT = 25

  validates :product_id, :model, :description, :upc, presence: true
  validates :price, :discount, :sort_order, presence: true
  validates :shipping_length, :shipping_width, :shipping_height, :shipping_weight, presence: true

  validates_inclusion_of :active, in: [true, false]

  validates :shipping_length, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 25
  }
  
  validates :shipping_width, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 13
  }
  
  validates :shipping_height, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than: 7
  }

  validates :kit_stock, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }, if: :is_a_kit?

  validates :partial_stock, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }, unless: :is_a_kit?

  validates :assembled_stock, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }, unless: :is_a_kit?

  validates :kits_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: :common_stock_count
  }, if: :is_a_kit?
  
  validates :partials_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: :common_stock_count
  }, unless: :is_a_kit?
  
  validates :assembled_to_make, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: :min_stock
  }, unless: :is_a_kit?

  def initialize(params)
    if params[:id]
      @option = Option.find(params[:id])
      @product = @option.product
      @bom = @option.bom
    elsif params[:product_id]
      @product = Product.find_by(model: params[:product_id])
      @option = Option.new(product: @product)
    else
      return nil
    end

    if params[:option_editor]
      @product.attributes = product_params(params)
      @option.attributes = option_params(params)
      @kits_to_make = param_to_i editor_params(params)[:kits_to_make]
      @partials_to_make = param_to_i editor_params(params)[:partials_to_make]
      @assembled_to_make = param_to_i editor_params(params)[:assembled_to_make]
    end
  end
  
  def model_name
    ActiveModel::Name.new(self, nil, 'OptionEditor')
  end

  def persisted?
    false
  end

  def product_model
    @product.model
  end

  def option_model
    @option.model
  end

  def subtract_stock(quantity)
    if is_a_kit?
      product.kit_stock -= quantity
      if product.kit_stock < 0
        bom.subtract_stock(-product.kit_stock)
        product.kit_stock = 0
      end
    else
      option.assembled_stock -= quantity
      if option.assembled_stock < 0
        product.partial_stock += option.assembled_stock
        option.assembled_stock = 0
      end
      if product.partial_stock < 0
        bom.subtract_stock(-product.partial_stock)
        product.partial_stock = 0
      end
    end
  end

  def make_kits(n = 0)
    return if !is_a_kit?
    return if n > common_stock_count
    bom.subtract_stock(product_stock_items, n)
    product.kit_stock += n
  end

  def make_partials(n = 0)
    return if is_a_kit?
    return if n > common_stock_count
    bom.subtract_stock(product_stock_items, n)
    product.partial_stock += n
  end

  def make_assembled(n = 0)
    return if is_a_kit?
    return if n > min_stock
    bom.subtract_stock(option_stock_items, n)
    option.assembled_stock += n
    product.partial_stock -= n
  end

  def reorder?
    common_stock_count < REORDER_LIMIT
  end

  def min_stock
    option_stock_count < partial_stock ? option_stock_count : partial_stock
  end

  def option_stock_count
    @option_stock_count ||= get_option_stock_count
  end

  def option_stock_items
    @option_stock_items ||= get_option_stock_items
  end

  def product_stock_items
    bom.bom_items - option_stock_items
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

private

  def get_option_stock_count
    items = option_stock_items
    items.map {|i| i.component.stock / i.quantity }.min
  end

  def get_option_stock_items
    items = common_stock_items
    items = items.group_by {|i| i.component_id}
    items = items.reject {|k,v| v.length == bom_count}
    items = items.flat_map {|k,v| v}
    items.select {|i| i.bom_id == bom.id}
  end

  def persist!
    if @option.is_a_kit?
      make_kits(kits_to_make)
    else
      make_partials(partials_to_make)
      make_assembled(assembled_to_make)
    end
    @product.save!
    @option.save!
  end

  def option_params(params)
    params.require(:option_editor).
    permit(:model, :description, :price, :discount, :upc, :active, :sort_order, :shipping_weight, :shipping_length, :shipping_width, :shipping_height, :assembled_stock)
  end

  def product_params(params)
    params.require(:option_editor).
    permit(:kit_stock, :partial_stock)
  end

  def editor_params(params)
    params.require(:option_editor).
    permit(:kits_to_make, :partials_to_make, :assembled_to_make)
  end

  def param_to_i(param)
    param.to_i if param
  end
end