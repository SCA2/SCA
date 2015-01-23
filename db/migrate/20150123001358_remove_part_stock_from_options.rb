class RemovePartStockFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :part_stock, :integer
  end
end
