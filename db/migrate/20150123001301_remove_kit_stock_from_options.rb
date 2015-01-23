class RemoveKitStockFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :kit_stock, :integer
  end
end
