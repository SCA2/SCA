class RemoveRemoveFromLineItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :remove, :boolean
  end
end
