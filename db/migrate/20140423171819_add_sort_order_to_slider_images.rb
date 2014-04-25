class AddSortOrderToSliderImages < ActiveRecord::Migration
  def change
    add_column :slider_images, :sort_order, :integer
  end
end
