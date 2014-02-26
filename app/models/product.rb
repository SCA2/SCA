class Product < ActiveRecord::Base
  
  has_many :features, inverse_of: :product, dependent: :destroy
  
  accepts_nested_attributes_for :features

  validates :model, :model_weight, :category, :category_weight,
            :short_description, :long_description, 
            :image_1, :upc, :price, presence: true
    
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

end
