class OrderPurchaser

  require 'active_merchant/billing/rails'

  def initialize(order, valid_card = nil)
    @order = order
    @cart = order.cart
    @total = order.total
    @credit_card = valid_card.credit_card if valid_card
  end

  def purchase
    response = process_purchase
    @order.transactions.create!(action: "purchase", amount: @total, response: response)
    @cart.update(purchased_at: Time.zone.now) if response.success?
    response.success?
  rescue StandardError => e
    @order.transactions.create(exception_params(e))
    false
  end
  
private
  
  def process_purchase
    if @order.standard_purchase?
      STANDARD_GATEWAY.purchase(@total, @credit_card, standard_purchase_options)
    else
      EXPRESS_GATEWAY.purchase(@total, express_purchase_options)
    end
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
  
  def standard_purchase_options
    billing = @order.billing_address
    {
      ip: @order.ip_address,
      billing_address: {
        name:       billing.first_name + ' ' + billing.last_name,
        address1:   billing.address_1,
        city:       billing.city,
        state_code: billing.state_code,
        country:    billing.country,
        zip:        billing.post_code
      }
    }
  end

  def express_purchase_options
    {
      ip:       @order.ip_address,
      token:    @order.express_token,
      payer_id: @order.express_payer_id
    }
  end
    
end