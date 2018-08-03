class AddComponentIdMiscIdToLineItem < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :component_id, :bigint
    add_column :line_items, :misc_id, :bigint
  end
end
