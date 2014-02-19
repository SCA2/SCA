class AddCategoryWeightToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :category_weight, :integer
  end
end
