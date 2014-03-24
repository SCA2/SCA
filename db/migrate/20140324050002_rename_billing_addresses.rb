class RenameBillingAddresses < ActiveRecord::Migration
  def change
    rename_column :addresses, :billing_first_name, :first_name
    rename_column :addresses, :billing_last_name, :last_name
    rename_column :addresses, :billing_address_1, :address_1
    rename_column :addresses, :billing_address_2, :address_2
    rename_column :addresses, :billing_city, :city
    rename_column :addresses, :billing_state, :state
    rename_column :addresses, :billing_post_code, :post_code
    rename_column :addresses, :billing_country, :country
    rename_column :addresses, :billing_telephone, :telephone
  end
end
