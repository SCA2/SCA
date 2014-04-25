class SliderImage < ActiveRecord::Base
  
  validates :name, :caption, :image_url, presence: true

end
