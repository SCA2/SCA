class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :model
      t.string :caption
      t.text :short_description
      t.text :long_description

      t.timestamps
    end
  end
end
