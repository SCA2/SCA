class ExpressValidator

  require 'active_merchant/billing/rails'

  def initialize(order, params)
    return false unless order && !order.purchased?
    return false unless params && params[:token]
    @order = order
    @details ||= EXPRESS_GATEWAY.details_for(params[:token])
    set_ip_address(params)
    set_express_token(params)
    set_express_id
    set_express_addresses
  end

private

  def set_express_addresses
    @order.update(email: @details.params["payer"])
    billing = @order.addresses.find_or_create_by(address_type: 'billing')
    billing.update(
      address_type: 'billing',
      first_name:   @details.params["first_name"],
      last_name:    @details.params["last_name"],
      address_1:    @details.params["street1"],
      address_2:    @details.params["street2"],
      city:         @details.params["city_name"],
      state_code:   @details.params["state_or_province"],
      country:      @details.params["country"],
      post_code:    @details.params["postal_code"],
      telephone:    @details.params["phone"]
    )
    shipping = @order.addresses.find_or_create_by(address_type: 'shipping')
    shipping.update(
      address_type: 'shipping',
      first_name:   @details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[0],
      last_name:    @details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[1],
      address_1:    @details.params["PaymentDetails"]["ShipToAddress"]["Street1"],
      address_2:    @details.params["PaymentDetails"]["ShipToAddress"]["Street2"],
      city:         @details.params["PaymentDetails"]["ShipToAddress"]["CityName"],
      state_code:   @details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
      country:      @details.params["PaymentDetails"]["ShipToAddress"]["Country"],
      post_code:    @details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
      telephone:    @details.params["PaymentDetails"]["ShipToAddress"]["Phone"]
    )
  end

  def set_express_token(params)
    @order.update(express_token: params[:token])
  end

  def set_express_id
    @order.update(express_payer_id: @details.payer_id)
  end

  def set_ip_address(params)
    @order.update(ip_address: params[:ip_address])
  end

end