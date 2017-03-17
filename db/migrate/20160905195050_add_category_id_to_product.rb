class AddCategoryIdToProduct < ActiveRecord::Migration
  def change
    add_reference :products, :product_category, index: true
  end
end
