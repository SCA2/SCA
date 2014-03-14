class AddCurrentOptionToOptions < ActiveRecord::Migration
  def change
    add_column :options, :current_option, :integer
  end
end
