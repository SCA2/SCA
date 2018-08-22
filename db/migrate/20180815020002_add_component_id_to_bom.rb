class AddComponentIdToBom < ActiveRecord::Migration[5.1]
  def change
    add_column :boms, :component_id, :integer
  end
end
