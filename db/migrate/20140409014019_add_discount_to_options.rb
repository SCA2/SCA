class AddDiscountToOptions < ActiveRecord::Migration
  def change
    add_column :options, :discount, :integer
  end
end
