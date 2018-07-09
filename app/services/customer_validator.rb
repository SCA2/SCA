class CustomerValidator

  include ActiveModel::Model

  attr_accessor :name, :email, :body
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :body, presence: true

  def initialize(params = nil)
    @name = params[:name] unless params.nil?
    @email = params[:email] unless params.nil?
    @body = params[:body] unless params.nil?
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'CustomerValidator')
  end

end