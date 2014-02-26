class AddIndexToFeatures < ActiveRecord::Migration
  def change
    add_index :features, [:product_id, :caption_sort_order]
  end
end
