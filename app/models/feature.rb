class Feature < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :features
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :sort_order, presence: true
  validates :caption, :description, presence: true
  
end
