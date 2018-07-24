class RenameProductModelSortOrder < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :model_sort_order, :sort_order
  end
end
