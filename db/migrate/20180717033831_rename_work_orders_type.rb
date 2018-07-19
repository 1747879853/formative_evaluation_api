class RenameWorkOrdersType < ActiveRecord::Migration[5.2]
  def change
  	rename_column :work_orders, :type,  :template_type
  end
end
