class StandardPurchaser

  require 'active_merchant/billing/rails'

  def initialize(order, valid_card)
    @order = order
    @cart = order.cart
    @credit_card = valid_card.credit_card
  end

  def purchase
    response = process_purchase
    @order.transactions.create!(action: "purchase", amount: @order.total, response: response)
    @cart.update(purchased_at: Time.zone.now) if response.success?
    response.success?
  rescue StandardError => e
    error_params = {
      action: 'exception',
      amount: @order.total,
      success: false,
      authorization: 'failed',
      message: e.message,
      params: {}
    }
    @order.transactions.create(error_params)
    false
  end
      
private

  def process_purchase
    if @order.express_token.blank?
      STANDARD_GATEWAY.purchase(@order.total, @credit_card, standard_purchase_options)
    end
  end

  def standard_purchase_options
    billing = @order.addresses.find_by(:address_type => 'billing')
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

end  
