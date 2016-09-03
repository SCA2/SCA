class OptionEditor

  include ActiveModel::Model

  delegate :product_id, :model, :description, :upc, to: :option
  delegate :price, :discount, :sort_order, :active, to: :option
  delegate :shipping_length, :shipping_width, to: :option 
  delegate :shipping_height, :shipping_weight, to: :option
  delegate :option_stock_items, :option_stock_count, to: :option
  delegate :assembled_stock, to: :option

  delegate :bom_count, :common_stock_items, :common_stock_count, to: :product
  delegate :kit_stock, :partial_stock, to: :product

  attr_accessor :kits_to_make, :partials_to_make, :assembled_to_make
  attr_reader :product, :option, :bom

  validates :product_id, :model, :description, :upc, presence: true
  validates :price, :discount, :sort_order, presence: true
  validates :shipping_length, :shipping_width, presence: true
  validates :shipping_height, :shipping_weight, presence: true

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
    less_than_or_equal_to: :limiting_stock
  }, unless: (:is_a_kit? || :new_option?)

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
      # @product.attributes = product_params(params)
      # @option.attributes = option_params(params)
      @product.update(product_params(params))
      @option.update(option_params(params))
      @kits_to_make = editor_params(params, :kits_to_make)
      @partials_to_make = editor_params(params, :partials_to_make)
      @assembled_to_make = editor_params(params, :assembled_to_make)
    end
  end

  def is_a_kit?
    @option.model.include?('KF') if @option.model
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

  def new_option?
    @option.new_record?
  end

  def make_kits(qty = 0)
    return unless bom
    return if !is_a_kit?
    return if qty > common_stock_count
    bom.subtract_stock(product_stock_items, qty)
    product.kit_stock += qty
  end

  def make_partials(qty = 0)
    return unless bom
    return if is_a_kit?
    return if qty > common_stock_count
    bom.subtract_stock(product_stock_items, qty)
    product.partial_stock += qty
  end

  def make_assembled(qty = 0)
    return unless bom
    return if is_a_kit?
    return if qty > limiting_stock
    bom.subtract_stock(option_stock_items, qty)
    option.assembled_stock += qty
    product.partial_stock -= qty
  end

  def limiting_stock
    option_stock_count < partial_stock ? option_stock_count : partial_stock
  end

  def product_stock_items
    return 0 unless bom
    bom.bom_items - option_stock_items
  end

  def save
    return false unless @product && @option && valid?
    persist!
    true
  end

  def save!
    save
  end

private

  def persist!
    unless @option.new_record?
      if @option.is_a_kit?
        make_kits(kits_to_make)
      else
        make_partials(partials_to_make)
        make_assembled(assembled_to_make)
      end
    end
    @product.save!
    @option.save!
  end

  def option_params(params)
    keys = [:model, :description, :price, :discount, :upc, :active, :sort_order, :shipping_weight, :shipping_length, :shipping_width, :shipping_height, :assembled_stock]
    params[:option_editor].select {|k,v| keys.include?(k.to_sym)}
  end

  def product_params(params)
    keys = [:kit_stock, :partial_stock]
    params[:option_editor].select {|k,v| keys.include?(k.to_sym)}
  end

  def editor_params(params, key)
    param_to_i params[:option_editor][key]
  end

  def param_to_i(param)
    param.to_i if param
  end
end