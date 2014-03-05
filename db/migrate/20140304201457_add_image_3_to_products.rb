class AddImage3ToProducts < ActiveRecord::Migration
  def change
    add_column :products, :image_3, :string
  end
end
