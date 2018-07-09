class AddDefaultsToOrders < ActiveRecord::Migration[5.1]
  def change
    change_column_default :orders, :shipping_cost, 0
    change_column_default :orders, :sales_tax, 0
    change_column_default :orders, :confirmed, false
  end
end
