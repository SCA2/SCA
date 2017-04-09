class InventoryCalculator

  delegate :option_stock_items, :option_stock, to: :option
  delegate :assembled_stock, :limiting_stock, to: :option
  delegate :is_kit?, :is_assembled?, to: :option

  delegate :bom_count, :common_stock_items, :common_stock, to: :product
  delegate :kit_stock, :partial_stock, to: :product

  attr_reader :product, :option, :bom

  def initialize(option: nil)
    @option = option
    @product = @option.product
    @bom = @option.bom
    return unless @product && @option && @bom
  rescue
    return false
  end

  def make_kits(quantity: 0)
    return unless is_kit?
    bom.subtract_stock(common_stock_items, quantity) if bom
    product.kit_stock += quantity
  end

  def sell_kits(quantity: 0)
    return unless is_kit?
    product.kit_stock -= quantity
    bom.subtract_stock(option_stock_items, quantity) if bom
    if bom && product.kit_stock < 0
      bom.subtract_stock(common_stock_items, -product.kit_stock)
      product.kit_stock = 0
    end
  end

  def make_partials(quantity: 0)
    return unless is_assembled?
    bom.subtract_stock(common_stock_items, quantity) if bom
    product.partial_stock += quantity
  end

  def make_assemblies(quantity: 0)
    return unless is_assembled?
    product.partial_stock -= quantity
    bom.subtract_stock(option_stock_items, quantity) if bom
    if bom && product.partial_stock < 0
      bom.subtract_stock(common_stock_items, -product.partial_stock)
      product.partial_stock = 0
    end
    option.assembled_stock += quantity
  end

  def sell_assemblies(quantity: 0)
    return unless is_assembled?
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

  def subtract_stock(quantity: 0)
    sell_kits(quantity: quantity)
    sell_assemblies(quantity: quantity)
  end

  def save_inventory
    @product.save!
    @option.save!
    @bom.save!
  end

end