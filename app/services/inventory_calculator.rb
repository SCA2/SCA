class InventoryCalculator

  delegate :option_stock_items, :option_stock, to: :option
  delegate :assembled_stock, :limiting_stock, to: :option

  delegate :bom_count, :common_stock_items, :common_stock, to: :product

  attr_reader :product, :option, :bom, :component, :quantity

  def initialize(item: nil)
    if item.itemizable_type == 'Option'
      @option = item.itemizable
      @product = @option.product
      @bom = @option.bom
      @quantity = item.quantity
      return unless @product && @option && @bom
    elsif item.itemizable_type == 'Component'
      @component = item.itemizable
      @quantity = item.quantity
    end
  rescue
    return false
  end

  def make_kits
    return unless option.is_kit?
    bom.subtract_stock(common_stock_items, quantity) if bom
    product.kit_stock += quantity
  end

  def sell_kits
    return unless option.is_kit?
    product.kit_stock -= quantity
    bom.subtract_stock(option_stock_items, quantity) if bom
    if bom && product.kit_stock < 0
      bom.subtract_stock(common_stock_items, -product.kit_stock)
      product.kit_stock = 0
    end
  end

  def make_partials
    return unless option.is_assembled?
    bom.subtract_stock(common_stock_items, quantity) if bom
    product.partial_stock += quantity
  end

  def make_assemblies
    return unless option.is_assembled?
    product.partial_stock -= quantity
    bom.subtract_stock(option_stock_items, quantity) if bom
    if bom && product.partial_stock < 0
      bom.subtract_stock(common_stock_items, -product.partial_stock)
      product.partial_stock = 0
    end
    option.assembled_stock += quantity
  end

  def sell_assemblies
    return unless option.is_assembled?
    option.assembled_stock -= quantity
    bom.subtract_stock(option_stock_items, quantity) if bom
    if option.assembled_stock < 0
      product.partial_stock += option.assembled_stock
      option.assembled_stock = 0
    end
    if bom && product.partial_stock < 0
      bom.subtract_stock(common_stock_items, -product.partial_stock)
      product.partial_stock = 0
    end
  end

  def sell_components
    return unless component
    component.stock -= quantity
  end

  def subtract_stock
    sell_components
    sell_kits
    sell_assemblies
  end

  def save_inventory
    @component.save! if component
    @product.save! if product
    @option.save! if option
    @bom.save! if bom
  end

end