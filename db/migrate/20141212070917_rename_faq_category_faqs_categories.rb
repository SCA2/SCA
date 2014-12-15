class RenameFaqCategoryFaqsCategories < ActiveRecord::Migration
  def change
    rename_table :faq_category, :faqs_categories
  end
end
