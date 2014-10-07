class DropFinishedStockFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :finished_stock, :integer
  end
end
