class AddBillingAddressToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_first_name, :string
    add_column :orders, :billing_last_name, :string
    add_column :orders, :billing_address_1, :string
    add_column :orders, :billing_address_2, :string
    add_column :orders, :billing_city, :string
    add_column :orders, :billing_state, :string
    add_column :orders, :billing_post_code, :string
    add_column :orders, :billing_country, :string
  end
end
