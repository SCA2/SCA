class DropdCurrentOptionFromOptions < ActiveRecord::Migration
  def change
    remove_column :options, :current_option, :integer
  end
end
