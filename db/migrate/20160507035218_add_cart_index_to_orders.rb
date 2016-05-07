class AddCartIndexToOrders < ActiveRecord::Migration
  def change
    add_index :orders, :cart_id
  end
end
