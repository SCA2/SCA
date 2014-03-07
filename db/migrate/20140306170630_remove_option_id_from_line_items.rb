class RemoveOptionIdFromLineItems < ActiveRecord::Migration
  def change
    remove_column :line_items, :option_id, :integer
  end
end
