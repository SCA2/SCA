class SliderImage < ActiveRecord::Base
  
  validates :name, :caption, :url, presence: true

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |image|
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
