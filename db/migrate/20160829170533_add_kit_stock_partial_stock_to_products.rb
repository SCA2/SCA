class AddKitStockPartialStockToProducts < ActiveRecord::Migration
  def change
    add_column :products, :partial_stock, :integer
    add_column :products, :kit_stock, :integer
  end
end
