class RenameFaqCategoryIdFaqsCategoryId < ActiveRecord::Migration
  def change
    rename_column :faqs, :faq_category_id, :faqs_category_id
  end
end
