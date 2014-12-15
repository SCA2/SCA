class AddFaqCategory < ActiveRecord::Migration
  def change
    create_table :faq_category do |t|
      t.string :category_name
      t.integer :category_weight
    end
  end
end
