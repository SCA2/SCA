class AddCaptionSortOrderToFeatures < ActiveRecord::Migration
  def change
    add_column :features, :caption_sort_order, :integer
  end
end
