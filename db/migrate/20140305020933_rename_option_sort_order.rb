class RenameOptionSortOrder < ActiveRecord::Migration
  def change
    change_table :options do |t|
      t.rename :option_sort_order,  :sort_order
    end
  end
end
