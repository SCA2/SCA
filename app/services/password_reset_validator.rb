class PasswordResetValidator

  include ActiveModel::Model

  attr_accessor :email
  
  validates :email, presence: true

  def initialize(params = nil)
    if params.present?
      @email = params[:password_reset][:email]
      @email.downcase!
    end
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'PasswordResetValidator')
  end

end