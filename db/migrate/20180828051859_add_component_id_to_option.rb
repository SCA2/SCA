class AddComponentIdToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :component_id, :bigint
  end
end
