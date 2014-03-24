class Address < ActiveRecord::Base
  
  belongs_to :cart
  
  validates :first_name, :last_name, :address_1, :city, :state, :country, :presence => true  

end
