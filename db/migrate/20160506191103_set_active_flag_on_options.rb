class SetActiveFlagOnOptions < ActiveRecord::Migration
  def up
    db.execute "UPDATE options SET active = true"
    change_column :options, :active, :boolean, null: false
  end
  
  private
  
  def db
    ActiveRecord::Base.connection
  end
end
