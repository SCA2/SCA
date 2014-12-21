class Feature < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :features
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :caption, :sort_order, :description, presence: true
  
end
