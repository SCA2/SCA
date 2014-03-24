class RenameBillinigCountry < ActiveRecord::Migration
  def change
    rename_column :addresses, :billinig_country, :billing_country
  end
end
