class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  accepts_nested_attributes_for :features
  
  has_many :line_items, inverse_of: :product
  accepts_nested_attributes_for :line_items
  
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :model, :model_sort_order, :category, :category_sort_order,
            :short_description, :long_description, 
            :image_1, :upc, :price, presence: true
    
  private
  
    def self.to_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |faq|
          csv << faq.attributes.values_at(*column_names)
        end
      end
    end
    
    def self.import(file)
      CSV.foreach(file.path, headers: true) do |row|
        faq = find_by_id(row['id']) || new
        faq.attributes = row.to_hash.slice(*accessible_attributes)
        faq.save!
      end
    end
    
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line items present')
        return false
      end
    end

end
