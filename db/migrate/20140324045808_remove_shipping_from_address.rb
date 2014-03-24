class RemoveShippingFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :shipping_first_name, :string
    remove_column :addresses, :shipping_last_name, :string
    remove_column :addresses, :shipping_address_1, :string
    remove_column :addresses, :shipping_address_2, :string
    remove_column :addresses, :shipping_city, :string
    remove_column :addresses, :shipping_state, :string
    remove_column :addresses, :shipping_post_code, :string
    remove_column :addresses, :shipping_country, :string
    remove_column :addresses, :shipping_telephone, :string
  end
end
