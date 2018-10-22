class AddDisplayCategoryIdToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :display_category_id, :integer
  end
end
