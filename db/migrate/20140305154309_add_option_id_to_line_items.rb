class AddOptionIdToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :option_id, :integer
  end
end
