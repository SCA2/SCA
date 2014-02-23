class Feature < ActiveRecord::Base
  
  validates :model, :caption, :short_description, presence: true
  
  belongs_to :product, inverse_of: :features
  
end
