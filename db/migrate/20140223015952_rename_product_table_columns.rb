class RenameProductTableColumns < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :name,       :model
      t.rename :photo1_url, :image_1
      t.rename :photo2_url, :image_2
    end
  end
end
