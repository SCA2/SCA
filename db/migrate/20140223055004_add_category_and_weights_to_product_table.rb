class AddCategoryAndWeightsToProductTable < ActiveRecord::Migration
  def change
    add_column :products, :category, :string
    add_column :products, :category_weight, :integer
    add_column :products, :model_weight, :integer
  end
end
