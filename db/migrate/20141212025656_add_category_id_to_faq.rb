class AddCategoryIdToFaq < ActiveRecord::Migration
  def change
    add_reference :faqs, :faq_category, index: true
  end
end
