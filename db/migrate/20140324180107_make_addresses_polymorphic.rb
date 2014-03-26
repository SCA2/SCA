class MakeAddressesPolymorphic < ActiveRecord::Migration
  def change
    add_column :addresses, :addressable_id, :integer
    add_column :addresses, :addressable_type, :string
    remove_column :addresses, :order_id, :integer
  end
end
