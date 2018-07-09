class SliderImage < ApplicationRecord
  
  validates :name, :caption, :image_url, presence: true

end
