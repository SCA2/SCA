class Rename < ActiveRecord::Migration
  def change
    change_table :features do |t|
      t.rename :caption_sort_order, :sort_order
      t.rename :short_description,  :description
      t.remove :long_description
    end
  end
end
