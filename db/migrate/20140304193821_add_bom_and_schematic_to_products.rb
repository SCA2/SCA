class AddBomAndSchematicToProducts < ActiveRecord::Migration
  def change
    add_column :products, :bom_1, :string
    add_column :products, :bom_2, :string
    add_column :products, :bom_3, :string
    add_column :products, :schematic_1, :string
    add_column :products, :schematic_2, :string
    add_column :products, :schematic_3, :string
  end
end
