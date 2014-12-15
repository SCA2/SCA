class RemoveCategoryWeightFromFaqs < ActiveRecord::Migration
  def change
    remove_column :faqs, :category_weight, :integer
  end
end
