class Address < ActiveRecord::Base
  
  belongs_to :addressable, :polymorphic => true
  
  validates :first_name, :last_name, :address_1, :city, :state, :country, :presence => true  

end
