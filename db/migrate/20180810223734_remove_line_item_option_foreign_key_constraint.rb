class RemoveLineItemOptionForeignKeyConstraint < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :line_items, name: "line_items_options_fk"
  end
end
