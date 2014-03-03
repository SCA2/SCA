class AddKfAndKaToProducts < ActiveRecord::Migration
  def change
    add_column :products, :kit, :string
    add_column :products, :option, :string
  end
end
