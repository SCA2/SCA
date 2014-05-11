class AddLengthWidthHeightToOptions < ActiveRecord::Migration
  def change
    add_column :options, :shipping_length, :integer
    add_column :options, :shipping_width, :integer
    add_column :options, :shipping_height, :integer
  end
end
