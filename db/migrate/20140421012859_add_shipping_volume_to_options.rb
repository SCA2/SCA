class AddShippingVolumeToOptions < ActiveRecord::Migration
  def change
    add_column :options, :shipping_volume, :integer
  end
end
