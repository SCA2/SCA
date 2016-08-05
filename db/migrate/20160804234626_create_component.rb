class CreateComponent < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :value
      t.string :marking
      t.string :description
      t.string :mfr
      t.string :vendor
      t.string :mfr_part_number
      t.string :vendor_part_number
      t.integer :stock
      t.integer :lead_time
      t.timestamps
    end
  end
end
