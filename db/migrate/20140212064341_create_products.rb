class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :short_description
      t.text :long_description
      t.string :upc
      t.string :photo1_url
      t.string :photo2_url
      t.decimal :price

      t.timestamps
    end
  end
end
