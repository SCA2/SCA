class AddInventoryToProducts < ActiveRecord::Migration
  def change
    add_column :products, :part_stock, :integer
    add_column :products, :kit_stock, :integer
    add_column :products, :finished_stock, :integer
  end
end
