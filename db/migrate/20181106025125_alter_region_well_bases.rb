class AlterRegionWellBases < ActiveRecord::Migration[5.2]
  def change
  	rename_column :region_well_bases, :well_base_id , :well_id
  end
end
