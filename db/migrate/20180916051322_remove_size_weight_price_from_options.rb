class RemoveSizeWeightPriceFromOptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :options, :model, :string 
    remove_column :options, :description, :string 
    remove_column :options, :price, :integer 
    remove_column :options, :upc, :string 
    remove_column :options, :shipping_weight, :integer 
    remove_column :options, :discount, :integer 
    remove_column :options, :shipping_length, :integer 
    remove_column :options, :shipping_width, :integer 
    remove_column :options, :shipping_height, :integer 
    remove_column :options, :assembled_stock, :integer 
  end
end
