class RemoveShippingVolumeFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :shipping_volume, :integer
  end
end
