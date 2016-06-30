class SalesTaxCalculator

  SALES_TAX = HashWithIndifferentAccess.new(CA: 9.5) # as percent

  def initialize(order)
    @order = order
    @cart = order.cart
  end

  def total
    subtotal + sales_tax + shipping_cost
  end

  def sales_tax
    tax = (subtotal * sales_tax_rate).round
  end

private

  def shipping_cost
    @shipping_cost ||= @order.shipping_cost
  end

  def subtotal
    @subtotal ||= @cart.subtotal
  end

  def sales_tax_rate
    state = @order.addresses.find_by(address_type: 'billing').state_code
    rate = SALES_TAX[state] ? SALES_TAX[state] : 0
    rate.to_f / 100
  end
  
end