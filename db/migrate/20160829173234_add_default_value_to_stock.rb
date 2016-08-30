class AddDefaultValueToStock < ActiveRecord::Migration
  def change
    change_column :options, :assembled_stock, :integer, default: 0
    change_column :products, :kit_stock, :integer, default: 0
    change_column :products, :partial_stock, :integer, default: 0
  end
end
