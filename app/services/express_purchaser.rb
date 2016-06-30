class ExpressPurchaser

  require 'active_merchant/billing/rails'

  def initialize(order, token = nil)
    @order = order
    @token = token
  end

  def express_token=(token)
    @order.write_attribute(:express_token, token)
    if !@order.purchased? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      @order.write_attribute(:express_payer_id, details.payer_id)
    end
  end

  def paypal_url
    return nil if @order.express_token.blank?
    EXPRESS_GATEWAY.redirect_url_for(@order.express_token)
  end

  def get_express_address(token)
    details = EXPRESS_GATEWAY.details_for(token)
    update(email: details.params["payer"])
    billing = addresses.find_or_create_by(address_type: 'billing')
    billing.update(
      address_type: 'billing',
      first_name:   details.params["first_name"],
      last_name:    details.params["last_name"],
      address_1:    details.params["street1"],
      address_2:    details.params["street2"],
      city:         details.params["city_name"],
      state_code:   details.params["state_or_province"],
      country:      details.params["country"],
      post_code:    details.params["postal_code"],
      telephone:    details.params["phone"]
    )
    shipping = addresses.find_or_create_by(address_type: 'shipping')
    shipping.update(
      address_type: 'shipping',
      first_name:   details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[0],
      last_name:    details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[1],
      address_1:    details.params["PaymentDetails"]["ShipToAddress"]["Street1"],
      address_2:    details.params["PaymentDetails"]["ShipToAddress"]["Street2"],
      city:         details.params["PaymentDetails"]["ShipToAddress"]["CityName"],
      state_code:   details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
      country:      details.params["PaymentDetails"]["ShipToAddress"]["Country"],
      post_code:    details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
      telephone:    details.params["PaymentDetails"]["ShipToAddress"]["Phone"]
    )
  end

end