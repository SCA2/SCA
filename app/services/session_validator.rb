class SessionValidator

  include ActiveModel::Model

  attr_accessor :password, :password_confirmation
  
  validates :password, presence: true
  validates :password, length: { minimum: 5 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  def initialize(params = nil)
    if params.present?
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'SessionValidator')
  end

end