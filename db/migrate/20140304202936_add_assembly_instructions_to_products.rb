class AddAssemblyInstructionsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :assembly_1, :string
    add_column :products, :assembly_2, :string
  end
end
