class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  # line_item has database foreign key constraint
  has_many :line_items, inverse_of: :product

  validates :model, :model_sort_order, :category, :category_sort_order,
            :short_description, :long_description, :image_1, presence: true 
            
  def to_param
    model.upcase
  end            
end
