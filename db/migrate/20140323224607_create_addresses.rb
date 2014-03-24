class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :order_id
      t.string :billing_first_name
      t.string :billing_last_name
      t.string :billing_address_1
      t.string :billing_address_2
      t.string :billing_city
      t.string :billing_state
      t.string :billing_post_code
      t.string :billing_country
      t.string :billing_telephone
      t.string :shipping_first_name
      t.string :shipping_last_name
      t.string :shipping_address_1
      t.string :shipping_address_2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_post_code
      t.string :shipping_country
      t.string :shipping_telephone

      t.timestamps
    end
  end
end
