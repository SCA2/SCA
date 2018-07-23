class RemoveCategoryFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :category, :string
    remove_column :products, :category_sort_order, :integer
  end
end
