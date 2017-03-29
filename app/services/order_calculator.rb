class OrderCalculator

  def initialize(order)
    @order = order
    @state = order.billing_address.state_code
  end

  def total
    subtotal + sales_tax + shipping_cost
  end

  def sales_tax
    tax = (subtotal * sales_tax_rate).round
  end

private

  SALES_TAX = HashWithIndifferentAccess.new(CA: 9.25) # as percent

  def shipping_cost
    @shipping_cost ||= @order.shipping_cost
  end

  def subtotal
    @subtotal ||= @order.subtotal
  end

  def sales_tax_rate
    rate = SALES_TAX[@state] ? SALES_TAX[@state] : 0
    rate.to_f / 100
  end
  
end