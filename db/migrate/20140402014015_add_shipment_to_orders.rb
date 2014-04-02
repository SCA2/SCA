class AddShipmentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :length, :float
    add_column :orders, :width, :float
    add_column :orders, :height, :float
    add_column :orders, :weight, :float
  end
end
