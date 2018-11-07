class CreateRegionWellBases < ActiveRecord::Migration[5.2]
  def change
    create_table :region_well_bases do |t|
      t.belongs_to :well_base, index: true
      t.belongs_to :region, index: true
      t.timestamps
    end
  end
end
