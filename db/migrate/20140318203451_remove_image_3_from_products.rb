class RemoveImage3FromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :image_3, :string
  end
end
