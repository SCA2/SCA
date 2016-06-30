class CardValidator

  include ActiveModel::Model
  require 'active_merchant/billing/rails'

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  CARD_TYPES = [
    ["Visa", "visa"],
    ["MasterCard", "master"],
    ["Discover", "discover"],
    ["American Express", "american_express"]
  ] 

  attr_reader :card_type, :card_number, :card_verification
  attr_reader :card_expires_on, :credit_card, :ip_address
  attr_accessor :email
  
  validate :validate_card

  validates :email, presence: true, format: { with: EMAIL_REGEX }

  def initialize(order, params = nil)
    @order = order
    @cart = order.cart
    @billing ||= @order.billing_address
    unless params.nil?
      @card_type = params[:card_type]
      @card_number = params[:card_number]
      @card_verification = params[:card_verification]
      @email = params[:email]
      @ip_address = params[:ip_address]
      self.card_expires_on = params
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'CardValidator')
  end

  def save
    @order.update(email: email, ip_address: ip_address)
  end
  
  def card_expires_on=(params)
    if params.nil?
      @card_expires_on = Date.yesterday
    else
      date = params.select {|p| p.include? 'card_expires_on'}.sort.map {|x, y| y}.join('-')
      @card_expires_on = Date.parse(date)
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      brand:              card_type,
      number:             card_number,
      verification_value: card_verification,
      month:              card_expires_on.month,
      year:               card_expires_on.year,
      first_name:         @billing.first_name,
      last_name:          @billing.last_name
    )
  end

private
  
  def validate_card
    if @order.express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] << message
      end
    end
  end
  
end  
