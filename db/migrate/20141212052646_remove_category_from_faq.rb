class RemoveCategoryFromFaq < ActiveRecord::Migration
  def change
    remove_column :faqs, :category, :string
  end
end
