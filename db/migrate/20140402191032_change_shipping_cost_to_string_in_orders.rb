class ChangeShippingCostToStringInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :shipping_cost, :string
  end
end
