class SliderImage < ActiveRecord::Base
  
  validates :name, :caption, :url, presence: true
  
end
