class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :options, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :options

  has_many :line_items, inverse_of: :product, dependent: :destroy
  
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :model, :model_sort_order, :category, :category_sort_order,
            :short_description, :long_description, :image_1, presence: true 
            
  
  
  private
  
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line items present')
        return false
      end
    end

end
