class Option < ActiveRecord::Base
  
  belongs_to :product, inverse_of: :options
  
  has_many :line_items, inverse_of: :options
  accepts_nested_attributes_for :line_items
  
  default_scope -> { order('sort_order ASC') }
  
  validates :product_id, :model, :description, :price, :sort_order, presence: true

end
