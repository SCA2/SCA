class SessionValidator

  include ActiveModel::Model

  attr_accessor :email, :password, :password_confirmation, :remember_me
  
  validates :email, presence: true
  validates :password, presence: true
  validates :password, length: { minimum: 5 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true
  validates :remember_me, presence: true

  def initialize(params = nil)
    if params.present?
      @email = params[:email]
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
      @remember_me = params[:remember_me]
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'SessionValidator')
  end

end