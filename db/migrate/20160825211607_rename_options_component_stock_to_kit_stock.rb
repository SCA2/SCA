class RenameOptionsComponentStockToKitStock < ActiveRecord::Migration
  def change
    rename_column :options, :component_stock, :kit_stock
  end
end
