class CreateSliderImages < ActiveRecord::Migration
  def change
    create_table :slider_images do |t|
      t.string :name
      t.text :caption
      t.string :url

      t.timestamps
    end
  end
end
