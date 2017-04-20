class Address < ActiveRecord::Base
  
  belongs_to :addressable, polymorphic: true
  
  validates :first_name, :last_name, :address_1, :city, :state_code, :country, presence: true, uniqueness: { scope: [:addressable_type, :addressable_id, :address_type] }

  validates :telephone, presence: true, unless: "country == 'US'"

  def self.billing_address
    find_by(address_type: 'billing')
  end

  def self.shipping_address
    find_by(address_type: 'shipping')
  end

end
