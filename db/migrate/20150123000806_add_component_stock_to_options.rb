class AddComponentStockToOptions < ActiveRecord::Migration
  def change
    add_column :options, :component_stock, :integer
  end
end
