class RemoveFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :part_stock, :integer  
    remove_column :products, :kit_stock, :integer  
    remove_column :products, :finished_stock, :integer  
    remove_column :products, :shipping_weight, :integer  
    remove_column :products, :bom_2, :string  
    remove_column :products, :bom_3, :string  
    remove_column :products, :schematic_2, :string  
    remove_column :products, :schematic_3, :string  
    remove_column :products, :assembly_2, :string
    rename_column :products, :bom_1, :bom  
    rename_column :products, :schematic_1, :schematic
    rename_column :products, :assembly_1, :assembly
  end
end
