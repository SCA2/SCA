class RemoveOptionIdAndItemizableTypeFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :option_id, :integer
    remove_column :line_items, :itemizable_type, :string
  end
end
