class OrderShipper

  require 'active_shipping'

  class ResponseError < ActiveShipping::ResponseError; end

  def initialize(order)
    @order = order
    @shipping_address = @order.shipping_address
  end

  def destination
    @destination ||= ActiveShipping::Location.new(
      country: @shipping_address.country,
      state: @shipping_address.state_code,
      city: @shipping_address.city,
      postal_code: @shipping_address.post_code
    )
  end

  def package
    ActiveShipping::Package.new(
      @order.weight,
      dimensions,
      cylinder: false,
      units: :imperial,
      currency: 'USD',
      value: @order.subtotal
    )
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, package)
    response.rates.sort_by(&:price)
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
    get_rates_from_shipper(usps).select do |rate|
      rate = rate.service_name.to_s
      if rate.include?('Hold')
        false
      elsif destination.country_code == 'US'
        rate.include?('Priority') &&
        rate.include?('Box') &&
        dimensions == [8, 5, 1.5]
      else
        !rate.include?('Envelope')
      end
    end
  rescue ActiveShipping::ResponseError => e
    raise ResponseError.new e.message
  end

  def dimensions
    boxes = [[8,5,1.5], [6,4,3], [11,8,5], [11,11,5], [24,12,6]]
    if box = boxes.select{|box| box_size(box)}.first
      box
    else
      [24, 12, 6]
    end
  end

private

  def origin
    ActiveShipping::Location.new(
      country: "US",
      state: "CA",
      city: "Oakland",
      postal_code: "94612"
    )
  end

  def box_size(box)
    length, width, height = box[0], box[1], box[2]
    volume = length * width * height
    return nil unless @order.total_volume < volume
    return nil unless @order.min_dimension < height
    return nil unless @order.max_dimension < length
    [length, width, height]
  end

end
