class RemoveKitStockPartialStockFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :partial_stock, :integer
    remove_column :options, :kit_stock, :integer
  end
end
