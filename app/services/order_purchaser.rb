class OrderPurchaser

  def initialize(order)
    @order = order
    @cart = order.cart
    @total = order.total
  end

  def purchase
    response = process_purchase
    record_transaction(response)
    response.successful?
  rescue StandardError => e
    @order.transactions.create(exception_params(e))
    false
  end
  
private

  def record_transaction(response)
    @order.transactions.create!(
      action: "stripe purchase",
      amount: response.amount,
      success: response.successful?,
      authorization: response.id,
      message: response.description,
      params: response.params
    )
    @cart.update(purchased_at: Time.zone.now) if response.successful?
  end
  
  def process_purchase
    StripeWrapper::Charge.create(stripe_purchase_options)
  end

  def exception_params(e)
    {
      action: 'exception',
      amount: @total,
      success: false,
      authorization: 'failed',
      message: e.message,
      params: {}
    }
  end
  
  def stripe_purchase_options
    {
      amount:       @total,
      currency:     'usd',
      description:  "Order: #{@order.id}, Cart: #{@cart.id}",
      source:       @order.stripe_token,
      metadata: {
        ip: @order.ip_address,
      }
    }
  end
    
end