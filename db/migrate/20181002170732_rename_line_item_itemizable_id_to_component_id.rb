class RenameLineItemItemizableIdToComponentId < ActiveRecord::Migration[5.1]
  def change
    rename_column :line_items, :itemizable_id, :component_id
  end
end
