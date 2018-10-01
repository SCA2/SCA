class OrderPurchaser

  def initialize(order)
    @order = order
    @cart = order.cart
    @total = order.total
  end

  def purchase
    response = StripeWrapper::Charge.create(stripe_purchase_options)
    if response.successful?
      @order.transactions.create!(success_params(response))
      @cart.update(purchased_at: Time.zone.now)
      true
    else
      @order.transactions.create!(exception_params(response.error_message))
      false
    end
  rescue StandardError => e
    @order.transactions.create!(exception_params(e.message))
    false
  end
  
private

  def stripe_purchase_options
    {
      amount:       @total,
      currency:     'usd',
      description:  "Email: #{@order.email}, Order: #{@order.id}, Cart: #{@cart.id}",
      source:       @order.stripe_token,
      metadata:     { ip: @order.ip_address }
    }
  end
    
  def success_params(response)
    {
      action: "stripe purchase",
      amount: response.amount,
      success: response.successful?,
      authorization: response.id,
      message: response.description,
      params: response.params
    }
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
  
end