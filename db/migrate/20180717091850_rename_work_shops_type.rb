class RenameWorkShopsType < ActiveRecord::Migration[5.2]
  def change
  		rename_column :work_shops, :type,  :dept_type
  end
end
