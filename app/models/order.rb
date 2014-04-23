class Order < ActiveRecord::Base

  include ActiveMerchant::Shipping

  belongs_to :cart, inverse_of: :order
  has_many :addresses, as: :addressable
  has_many :transactions
  
  accepts_nested_attributes_for :addresses
  
  attr_accessor :card_number, :card_verification, :ip_address, :order_ready
  
  validate :validate_card, if: :order_ready?

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    if: :order_ready?


  CARD_TYPES = [["Visa", "visa"],["MasterCard", "master"], ["Discover", "discover"], ["American Express", "american_express"]] 
  
  def purchase
    response = process_purchase
    transactions.create!(:action => "purchase", :amount => total_in_cents, :response => response)
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
    self.update(email: details.params["payer"])
    self.addresses.create!(:address_type => 'billing',
      :first_name => details.params["first_name"],
      :last_name => details.params["last_name"],
      :address_1 => details.params["street1"],
      :address_2 => details.params["street2"],
      :city => details.params["city_name"],
      :state_code => details.params["state_or_province"],
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
      :state_code => details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
      :country => details.params["PaymentDetails"]["ShipToAddress"]["Country"],
      :post_code => details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
      :telephone => details.params["PaymentDetails"]["ShipToAddress"]["Phone"],
    )
  end

  def total(cart)
    cart.subtotal + sales_tax + shipping_cost.to_f / 100
  end
  
  def total_in_cents
    (total(cart) * 100).round
  end
  
  def subtotal(cart)
    cart.subtotal
  end
  
  def subtotal_in_cents
    (subtotal(cart) * 100).round
  end
  
  def origin
    Location.new(country: "US", state: "CA", city: "Oakland", postal_code: "94612")
  end
 
  def destination
    shipping = self.addresses.find_by(:address_type => 'shipping')
    Location.new(country: shipping.country, state: shipping.state_code, city: shipping.city, postal_code: shipping.post_code)
  end
 
  def packages
    package = Package.new(self.cart.weight,
                          dimensions,
                          :cylinder => false,
                          :units => :imperial,
                          :currency => 'USD',
                          :value => cart.subtotal * 100)        
  end
 
  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    logger.debug "response: " + response.inspect
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
    usps = USPS.new(login: '825SEVEN1015', password: '391FA81EE622')
    get_rates_from_shipper(usps)
  end

  SALES_TAX = HashWithIndifferentAccess.new(CA: 900)
    
  def sales_tax
    state = addresses.find_by(address_type: 'shipping').state_code
    if SALES_TAX[state]
      (cart.subtotal * SALES_TAX[state]).to_f / 10000
    else
      0
    end
  end
  
  def dimensions
    case cart.total_volume
    when 0 .. (6 * 4 * 3)
      length = 6
      width = 4
      height = 3
    when (6 * 4  * 3) .. (12 * 9 * 6)
      length = 12
      width = 9
      height = 6
    when (12 * 9  * 6) .. (12 * 12 * 10)
      length = 12
      width = 12
      height = 10
    when (12 * 12  * 10) .. (24 * 12 * 6)
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
  
  private
  
  def process_purchase
    if express_token.blank?
      STANDARD_GATEWAY.purchase(total_in_cents, credit_card, standard_purchase_options)
    else
      EXPRESS_GATEWAY.purchase(total_in_cents, express_purchase_options)
    end
  end
  
  def standard_purchase_options
    billing = addresses.find_by(:address_type => 'billing')
    {
      :ip => ip_address,
      :billing_address => {
        :name       => billing.first_name + ' ' + billing.last_name,
        :address1   => billing.address_1,
        :city       => billing.city,
        :state_code => billing.state_code,
        :country    => billing.country,
        :zip        => billing.post_code
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
        errors[:base] << message
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
  
  def order_ready?
    if order_ready == true
      return true
    else
      return false
    end
  end

end