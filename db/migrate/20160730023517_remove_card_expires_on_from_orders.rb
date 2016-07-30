class RemoveCardExpiresOnFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :card_expires_on, :date
  end
end
