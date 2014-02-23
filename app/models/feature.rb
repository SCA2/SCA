class Feature < ActiveRecord::Base
  
  validates :model, :caption, :short_description, presence: true
  
end
