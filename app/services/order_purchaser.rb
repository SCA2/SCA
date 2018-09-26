class OrderPurchaser

  def initialize(order)
    @order = order
    @cart = order.cart
    @total = order.total
  end

  def purchase
    response = process_purchase
    if response.successful?
      record_transaction(response)
      true
    else
      @order.transactions.create(exception_params(response.error_message))
      false
    end
  rescue StandardError => e
    @order.transactions.create(exception_params(e.message))
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

  def exception_params(message)
    {
      action: 'exception',
      amount: @total,
      success: false,
      authorization: 'failed',
      message: message,
      params: {}
    }
  end
  
  def stripe_purchase_options
    {
      amount:       @total,
      currency:     'usd',
      description:  "Email: #{@order.email}, Order: #{@order.id}, Cart: #{@cart.id}",
      source:       @order.stripe_token,
      metadata:     { ip: @order.ip_address }
    }
  end
    
end