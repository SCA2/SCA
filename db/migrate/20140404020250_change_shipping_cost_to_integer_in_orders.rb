class ChangeShippingCostToIntegerInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :shipping_cost, :integer
  end
end
