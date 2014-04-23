class RemoveLengthWidthHeightWeightFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :length, :float
    remove_column :orders, :width, :float
    remove_column :orders, :height, :float
    remove_column :orders, :weight, :float
  end
end
