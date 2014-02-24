class AddNotesToProducts < ActiveRecord::Migration
  def change
    add_column :products, :notes, :text
  end
end
