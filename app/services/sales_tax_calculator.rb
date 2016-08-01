class SalesTaxCalculator

  def initialize(range)
    @range = range
  end

  def all_orders
    @all_orders ||= Order.includes(:cart).where(carts: { purchased_at: @range })
  end

  def taxable_orders
    @taxable_orders ||= all_orders.
      includes(:addresses).
      where(addresses: { address_type: 'billing' }).
      where(addresses: { state_code: 'CA' })
  end

  def gross_sales
    @gross_sales ||= all_orders.reduce(0) { |sum, order| sum + order.total }
  end

  def taxable_sales
    @taxable_sales ||= taxable_orders.reduce(0) { |sum, order| sum + order.total }
  end

  def excluded_sales
    gross_sales - taxable_sales
  end

  def excluded_shipping
    taxable_orders.sum(:shipping_cost)
  end

  def tax_withheld
    taxable_orders.sum(:sales_tax)
  end

end