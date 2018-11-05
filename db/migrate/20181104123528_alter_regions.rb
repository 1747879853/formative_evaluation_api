class AlterRegions < ActiveRecord::Migration[5.2]
  def change
  	rename_column :regions, :name , :title
  end
end
