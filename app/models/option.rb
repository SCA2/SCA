class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :description, :price, :sort_order, presence: true

end
