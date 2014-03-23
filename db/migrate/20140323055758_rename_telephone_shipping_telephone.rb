class RenameTelephoneShippingTelephone < ActiveRecord::Migration
  def change
    change_table :orders do |t|
      t.rename :telephone,  :shipping_telephone
    end
  end
end
