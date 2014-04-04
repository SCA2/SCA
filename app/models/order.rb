class Order < ActiveRecord::Base

  include ActiveMerchant::Shipping

  belongs_to :cart
  has_many :addresses, as: :addressable
  has_many :transactions
  
  accepts_nested_attributes_for :addresses
  
  attr_accessor :card_number, :card_verification, :ip_address
  
  validate :validate_card, :on => :save
  
  CARD_TYPES = [["Visa", "visa"],["MasterCard", "master"], ["Discover", "discover"], ["American Express", "american_express"]] 
  
  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    if response.success?
      cart.update(:purchased_at => Time.now) 
    end
    response.success?
  end
  
  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
    end
  end

  def get_express_address(token)
    details = EXPRESS_GATEWAY.details_for(token)
    self.addresses.create!(:address_type => 'billing',
      :first_name => details.params["first_name"],
      :last_name => details.params["last_name"],
      :address_1 => details.params["street1"],
      :address_2 => details.params["street2"],
      :city => details.params["city_name"],
      :state => details.params["state_or_province"],
      :country => details.params["country"],
      :post_code => details.params["postal_code"],
      :telephone => details.params["phone"]
    )
    self.addresses.create!(:address_type => 'shipping',
      :first_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[0],
      :last_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[1],
      :address_1 => details.params["PaymentDetails"]["ShipToAddress"]["Street1"],
      :address_2 => details.params["PaymentDetails"]["ShipToAddress"]["Street2"],
      :city => details.params["PaymentDetails"]["ShipToAddress"]["CityName"],
      :state => details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
      :country => details.params["PaymentDetails"]["ShipToAddress"]["Country"],
      :post_code => details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
      :telephone => details.params["PaymentDetails"]["ShipToAddress"]["Phone"],
    )
  end

  def price_in_cents
    (total(cart) * 100).round
  end
  
  def origin
    Location.new(country: "US", state: "CA", city: "Oakland", postal_code: "94612")
  end
 
  def destination
    shipping = self.addresses.find_by(:address_type => 'shipping')
    Location.new(country: shipping.country, state: shipping.state, city: shipping.city, postal_code: shipping.post_code)
  end
 
  def packages
    package = Package.new(weight, [length, width, height], cylinder: false)
  end
 
  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
  end
  
  def get_rates_from_params
    method = shipping_method.split(',')[0].strip  
    cost = shipping_method.split(',')[1].strip.to_i
    self.update(shipping_method: method, shipping_cost: cost)
  end
  
  def ups_rates
    ups = UPS.new(login: 'tpryan', password: 'ups1138', key: 'DC1022E5FAC7AD60')
    get_rates_from_shipper(ups)
  end
 
  def usps_rates
    usps = USPS.new(login: 'your usps account number', password: 'your usps password')
    get_rates_from_shipper(usps)
  end

  def total(cart)
    cart.subtotal + shipping_cost.to_f / 100
  end
  
  private
  
  def process_purchase
    if express_token.blank?
      STANDARD_GATEWAY.purchase(price_in_cents, credit_card, standard_purchase_options)
    else
      EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    end
  end
  
  def standard_purchase_options
    billing = addresses.find_by(:address_type => 'billing')
    {
      :ip => ip_address,
      :billing_address => {
        :name     => billing.first_name + ' ' + billing.last_name,
        :address1 => billing.address_1,
        :city     => billing.city,
        :state    => billing.state,
        :country  => billing.country,
        :zip      => billing.post_code
      }
    }
  end
  
  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end
  
  def validate_card
    if express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
  def credit_card
    billing = addresses.find_by(:address_type => 'billing')
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      type:               card_type,
      number:             card_number,
      verification_value: card_verification,
      month:              card_expires_on.month,
      year:               card_expires_on.year,
      first_name:         billing.first_name,
      last_name:          billing.last_name
    )
  end
  
end