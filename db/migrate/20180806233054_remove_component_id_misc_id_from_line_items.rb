class RemoveComponentIdMiscIdFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :component_id, :bigint
    remove_column :line_items, :misc_id, :bigint
  end
end
