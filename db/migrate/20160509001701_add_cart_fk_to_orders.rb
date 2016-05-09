class AddCartFkToOrders < ActiveRecord::Migration
  def change
    add_foreign_key :orders, :carts, name: 'orders_carts_fk', on_delete: :restrict
  end
end
