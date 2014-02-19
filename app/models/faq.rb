class Faq < ActiveRecord::Base
  
  validates :category, :category_weight, :question, :question_weight, :answer, presence: true
  
  validates :category, inclusion: { in: %w(General Ordering Assembly Support),
                                 message: "--> %{value} is not a valid category" }
  validates :category_weight, :question_weight, 
    numericality: {only_integer: true, greater_than: 0, less_than: 101}
                                      
  validates :question, uniqueness: { scope: :category }
  
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
