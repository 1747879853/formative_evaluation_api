class AlterWellBaseName < ActiveRecord::Migration[5.2]
  def change
    rename_table :region_well_bases,:region_wells
  end
end
