class RenameUrlToImageUrlInSliderImages < ActiveRecord::Migration
  def change
    rename_column :slider_images, :url, :image_url
    add_column :slider_images, :product_url, :string
  end
end
