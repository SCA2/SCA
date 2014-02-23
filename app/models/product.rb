class Product < ActiveRecord::Base
  
    validates :model, :upc, :short_description, :long_description, :image_1, presence: true
    
    has_many :features, inverse_of: :product

end
