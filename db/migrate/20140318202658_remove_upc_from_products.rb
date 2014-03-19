class RemoveUpcFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :upc, :string
  end
end
