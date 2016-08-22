class AddOptionReferenceToBoms < ActiveRecord::Migration
  def change
    add_reference :boms, :option, foreign_key: true
  end
end
