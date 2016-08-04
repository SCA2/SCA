class CreateBomItems < ActiveRecord::Migration
  def change
    create_table :bom_items do |t|
      t.integer :quantity
      t.string :reference
      t.belongs_to :bom
      t.belongs_to :component
      t.timestamps
    end
  end
end
