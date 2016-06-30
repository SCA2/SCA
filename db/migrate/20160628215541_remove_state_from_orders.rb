class RemoveStateFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :state, :integer, :string
  end
end
