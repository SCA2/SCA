class AddAssembledPartialStockToOptions < ActiveRecord::Migration
  def change
    add_column :options, :assembled_stock, :integer
    add_column :options, :partial_stock, :integer
  end
end
