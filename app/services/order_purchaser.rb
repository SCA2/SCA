class OrderPurchaser

  include ActiveModel::Validations
  require 'active_merchant/billing/rails'

  CARD_TYPES = [
    ["Visa", "visa"],
    ["MasterCard", "master"],
    ["Discover", "discover"],
    ["American Express", "american_express"]
  ] 

  attr_accessor :card_type, :card_number, :card_verification, :card_expires_on
  attr_accessor :ip_address, :express_token, :express_payer_id

  validate :validate_card, if: :validate_order?

  def initialize(order, order_params)
    @order = order
    @cart = order.cart
    @card_type = order_params[:card_type]
    @card_number = order_params[:card_number]
    @card_verification = order_params[:card_verification]
    @card_expires_on = @order.card_expires_on
    @ip_address = order_params[:ip_address]
  end

  def purchase
    response = process_purchase
    @order.transactions.create!(action: "purchase", amount: total, response: response)
    @cart.update(purchased_at: Time.zone.now) if response.success?
    response.success?
  rescue StandardError => e
    error_params = {
      action: 'exception',
      amount: total,
      success: false,
      authorization: 'failed',
      message: e.message,
      params: {}
    }
    transactions.create(error_params)
    false
  end
  
private
  
  def process_purchase
    if @order.express_token.blank?
      STANDARD_GATEWAY.purchase(total, credit_card, standard_purchase_options)
    else
      EXPRESS_GATEWAY.purchase(total, express_purchase_options)
    end
  end
  
  def standard_purchase_options
    billing = @order.addresses.find_by(:address_type => 'billing')
    {
      ip: ip_address,
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
      ip:       ip_address,
      token:    express_token,
      payer_id: express_payer_id
    }
  end
  
  def validate_card
    if @order.express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] << message
      end
    end
  end
  
  def credit_card
    billing = @order.addresses.find_by(:address_type => 'billing')
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      brand:              card_type,
      number:             card_number,
      verification_value: card_verification,
      month:              card_expires_on.month,
      year:               card_expires_on.year,
      first_name:         billing.first_name,
      last_name:          billing.last_name
    )
  end
end