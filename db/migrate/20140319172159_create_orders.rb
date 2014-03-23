class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :cart_id
      t.string :first_name
      t.string :last_name
      t.string :shipping_address_1
      t.string :shipping_address_2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_post_code
      t.string :shipping_country
      t.string :email
      t.string :telephone
      t.string :card_type
      t.date :card_expires_on
      t.integer :cart_id

      t.timestamps
    end
  end
end
