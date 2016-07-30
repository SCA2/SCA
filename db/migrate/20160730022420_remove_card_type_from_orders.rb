class RemoveCardTypeFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :card_type, :string
  end
end
