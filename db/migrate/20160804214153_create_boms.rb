class CreateBoms < ActiveRecord::Migration
  def change
    create_table :boms do |t|
      t.integer :product_id
      t.string :revision
      t.string :pdf
      t.timestamps
    end
  end
end
