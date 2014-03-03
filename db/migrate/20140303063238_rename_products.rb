class RenameProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :category_weight, :category_sort_order
      t.rename :model_weight, :model_sort_order
    end
  end
end
