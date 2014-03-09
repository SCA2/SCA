class AddRemoveToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :remove, :boolean, default: false
  end
end
