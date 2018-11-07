class AlterRegionWellBasesAgain < ActiveRecord::Migration[5.2]
  def change
  	change_column :region_well_bases, :well_id, :string
  end
end
