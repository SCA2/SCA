class CardTokenizer

  include ActiveModel::Model

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  attr_accessor :stripe_token, :email, :postcode, :ip_address

  validates :email, presence: true, format: { with: EMAIL_REGEX }
  validates :stripe_token, presence: true

  def initialize(order, params = nil)
    @order = order
    unless params.nil?
      @stripe_token = params[:stripe_token]
      @email = params[:email]
      @ip_address = params[:ip_address]
      @postcode = params[:postcode]
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'CardTokenizer')
  end

  def save
    @order.update(email: email, ip_address: ip_address, stripe_token: stripe_token)
  end
  
end  