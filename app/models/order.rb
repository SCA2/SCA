class Order < ActiveRecord::Base

  belongs_to :cart
  has_many :addresses, as: :addressable
  has_many :transactions
  
  accepts_nested_attributes_for :addresses
  
  attr_accessor :checkout_method, :shipping_cost, :card_number, :card_verification, :ip_address
  
  validate :validate_card, :on => :save
  
  CARD_TYPES = [["Visa", "visa"],["MasterCard", "master"], ["Discover", "discover"], ["American Express", "american_express"]] 
  
  def purchase
    response = process_purchase
    self.transactions.create!(  :action => "purchase", 
                                :amount => price_in_cents,
                                :response => response)
    
    transaction = self.transactions.find_by(order_id: self.id)                            
    if response.success?
      transaction.update(:purchased_at => Time.now) 
    else
      transaction.update(:purchased_at => nil)
    end
    response.success?
  end
  
  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  def price_in_cents
    (cart.total_price*100).round
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
  
  def transaction_params
      params.require(:transaction).permit(:purchased_at)
  end
  
end