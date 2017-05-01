class User < ActiveRecord::Base
  
  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses, 
                                :allow_destroy => true, 
                                :reject_if => proc { |a|
                                  a[:first_name].blank? &&
                                  a[:last_name].blank? &&
                                  a[:address_1].blank? &&
                                  a[:city].blank?
                                }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }
  before_create :create_remember_token
    
  validates :name, presence: true, length: { maximum: 40 }
  
  validates :email,
    presence: true, 
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  
  has_secure_password
  validates :password, presence: true
  validates :password, length: { minimum: 5 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  def User.new_remember_token
    begin
      t = SecureRandom.urlsafe_base64
    end while User.exists?(:remember_token => t)
    return t
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def send_password_reset
    create_reset_token
    self.update_attribute(:password_reset_sent_at, Time.now)
    UserMailer.password_reset(self).deliver_now
  end

  def billing_address
    addresses.billing_address
  end

  def shipping_address
    addresses.shipping_address
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
    
    def create_reset_token
      self.password_reset_token = User.encrypt(User.new_remember_token)
    end

end
