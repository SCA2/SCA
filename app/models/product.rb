class Product < ActiveRecord::Base
  
    validates :model, :upc, :short_description, :long_description, :image_1, presence: true

end
