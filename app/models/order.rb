class Order < ActiveRecord::Base

  include ActiveMerchant::Shipping

  CARD_TYPES = [["Visa", "visa"],["MasterCard", "master"], ["Discover", "discover"], ["American Express", "american_express"]] 

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  STATES = %w[order_started order_addressed shipping_method_selected order_confirmed payment_submitted transaction_succeeded transaction_failed order_canceled order_shipped]
  
  VIEWABLE_STATES = %w[order_started order_addressed shipping_method_selected order_confirmed]

  SALES_TAX = HashWithIndifferentAccess.new(CA: 900)

  belongs_to :cart, inverse_of: :order
  has_many :addresses, as: :addressable
  has_many :transactions

  accepts_nested_attributes_for :addresses

  attr_accessor :card_number, :card_verification, :ip_address, :validate_order, :validate_terms, :accept_terms
  
  validate :validate_card, if: :validate_order?
  validates :accept_terms, acceptance: true, if: :validate_terms?
  # validates_inclusion_of :state, in: STATES

  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    if: :validate_order?


  def purchase
    response = process_purchase
    transactions.create!(action: "purchase", amount: total_in_cents, response: response)
    cart.update(purchased_at: Time.zone.now) if response.success?
    response.success?
  end

  def purchased?
    if cart
      cart.purchased?
    else
      false
    end
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
    update(email: details.params["payer"])
    if addresses.where(address_type: 'billing').exists?
      addresses.first.update(
        :address_type => 'billing',
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
    else
      addresses.create!(
        :address_type => 'billing',
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
    end
    if addresses.where(address_type: 'shipping').exists?
      addresses.last.update(
        :address_type => 'shipping',
        :first_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[0],
        :last_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[1],
        :address_1 => details.params["PaymentDetails"]["ShipToAddress"]["Street1"],
        :address_2 => details.params["PaymentDetails"]["ShipToAddress"]["Street2"],
        :city => details.params["PaymentDetails"]["ShipToAddress"]["CityName"],
        :state_code => details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
        :country => details.params["PaymentDetails"]["ShipToAddress"]["Country"],
        :post_code => details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
        :telephone => details.params["PaymentDetails"]["ShipToAddress"]["Phone"]
      )
    else
      addresses.create!(
        :address_type => 'shipping',
        :first_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[0],
        :last_name => details.params["PaymentDetails"]["ShipToAddress"]["Name"].split(' ')[1],
        :address_1 => details.params["PaymentDetails"]["ShipToAddress"]["Street1"],
        :address_2 => details.params["PaymentDetails"]["ShipToAddress"]["Street2"],
        :city => details.params["PaymentDetails"]["ShipToAddress"]["CityName"],
        :state_code => details.params["PaymentDetails"]["ShipToAddress"]["StateOrProvince"],
        :country => details.params["PaymentDetails"]["ShipToAddress"]["Country"],
        :post_code => details.params["PaymentDetails"]["ShipToAddress"]["PostalCode"],
        :telephone => details.params["PaymentDetails"]["ShipToAddress"]["Phone"]
      )
    end
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
  
  def prune_response(response)
    usps = response.rates.select do |str|
      (str.service_name.to_s.include? "USPS") && 
      (str.service_name.to_s.include? "Priority") &&
      !(str.service_name.to_s.include? "Hold")
    end
    ups = response.rates.select do |str|
      str.service_name.to_s.include? "UPS"
    end
    return ups + usps
  end
 
  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
    prune_response(response)    
  end
  
  def get_rates_from_params
    method = shipping_method.split(',')[0].strip  
    cost = shipping_method.split(',')[1].strip.to_i
    self.update(shipping_method: method, shipping_cost: cost)
  end
  
  def ups_rates
    ups = UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    get_rates_from_shipper(ups)
  end
 
  def usps_rates
    usps = USPS.new(login: ENV['USPS_LOGIN'], password: ENV['USPS_PASSWORD'])
    get_rates_from_shipper(usps)
  end

  def sales_tax
    state = addresses.find_by(address_type: 'shipping').state_code
    if SALES_TAX[state]
      (cart.subtotal * SALES_TAX[state]).to_f / 10000
    else
      0
    end
  end
  
  def dimensions
    max_dimension = cart.max_dimension
    case cart.total_volume
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
  
  delegate :order_started?, :order_addressed?, :shipping_method_selected?, :order_confirmed?, :payment_submitted?, :transaction_succeeded?, :transaction_failed?, :order_canceled?, :order_shipped?, to: :current_state
  
  def self.open_orders
    joins(:events).merge OrderEvent.with_last_state("open")
  end

  def current_state
    (state || STATES.first).inquiry
  end

  # [order_started order_addressed shipping_method_selected order_confirmed payment_submitted transaction_succeeded order_shipped token_received transaction_failed order_canceled]

  def next_state(event = nil)
    case current_state
    when 'payment_submitted'
      event == :success ? 'transaction_succeeded' : 'transaction_failed'
    when 'transaction_succeeded'
      event == :ship ? 'order_shipped' : current_state
    else
      STATES[STATES.index(current_state) + 1]
    end
  end

  def viewable?
    VIEWABLE_STATES.include?(current_state)
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
  
  def validate_order?
    if validate_order == true
      return true
    else
      return false
    end
  end

  def validate_terms?
    if validate_terms == true
      return true
    else
      return false
    end
  end

end