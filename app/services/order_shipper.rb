class OrderShipper

  require 'active_shipping'

  class ResponseError < ActiveShipping::ResponseError; end

  def initialize(order)
    @order = order
    @cart = order.cart
  end

  def origin
    ActiveShipping::Location.new(
      country: "US",
      state: "CA",
      city: "Oakland",
      postal_code: "94612"
    )
  end

  def destination
    shipping = @order.addresses.find_by(address_type: 'shipping')
    ActiveShipping::Location.new(
      country: shipping.country,
      state: shipping.state_code,
      city: shipping.city,
      postal_code: shipping.post_code
    )
  end

  def packages
    package = ActiveShipping::Package.new(
      @cart.weight,
      dimensions,
      cylinder: false,
      units: :imperial,
      currency: 'USD',
      value: @cart.subtotal
    )
  end

  def prune_response(response)
    usps = response.rates.select do |rate|
      (rate.service_name.to_s.include? "USPS") && 
      (rate.service_name.to_s.include? "Priority") &&
      !(rate.service_name.to_s.include? "Hold")
    end
    ups = response.rates.select do |rate|
      rate.service_name.to_s.include? "UPS"
    end
    return ups + usps
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
    prune_response(response)    
  end

  def get_rates_from_params(shipping_method)
    method = shipping_method.split(',')[0].strip  
    cost = shipping_method.split(',')[1].strip.to_i
    @order.update(shipping_method: method, shipping_cost: cost)
  rescue NoMethodError => e
    raise NoMethodError.new e.message
  end

  def ups_rates
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    get_rates_from_shipper(ups)
  rescue ActiveShipping::ResponseError => e
    raise ResponseError.new e.message
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'], password: ENV['USPS_PASSWORD'])
    get_rates_from_shipper(usps)
  rescue ActiveShipping::ResponseError => e
    raise ResponseError.new e.message
  end

  def dimensions
    max_dimension = @cart.max_dimension
    case @cart.total_volume
    when (0 .. (6 * 4 * 3)) && max_dimension < 6
      length = 6
      width = 4
      height = 3
    when ((6 * 4  * 3) .. (11 * 8 * 5)) && max_dimension < 11
      length = 11
      width = 8
      height = 5
    when ((6 * 4  * 3) .. (12 * 9 * 6)) && max_dimension < 12
      length = 12
      width = 9
      height = 6
    when ((12 * 9  * 6) .. (12 * 12 * 12)) && max_dimension < 12
      length = 12
      width = 12
      height = 12
    when ((12 * 12  * 12) .. (24 * 12 * 6)) && max_dimension < 24
      length = 24
      width = 12
      height = 6
    else
      length = 24
      width = 12
      height = 6
    end
    return [length, width, height]  
  end
end
