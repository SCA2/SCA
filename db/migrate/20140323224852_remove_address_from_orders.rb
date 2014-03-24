class RemoveAddressFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :shipping_first_name, :string
    remove_column :orders, :shipping_last_name, :string
    remove_column :orders, :shipping_address_1, :string
    remove_column :orders, :shipping_address_2, :string
    remove_column :orders, :shipping_city, :string
    remove_column :orders, :shipping_state, :string
    remove_column :orders, :shipping_post_code, :string
    remove_column :orders, :shipping_country, :string
    remove_column :orders, :shipping_telephone, :string
    remove_column :orders, :billing_first_name, :string
    remove_column :orders, :billing_last_name, :string
    remove_column :orders, :billing_address_1, :string
    remove_column :orders, :billing_address_2, :string
    remove_column :orders, :billing_city, :string
    remove_column :orders, :billing_state, :string
    remove_column :orders, :billing_post_code, :string
    remove_column :orders, :billing_country, :string
    remove_column :orders, :billing_telephone, :string
  end
end
