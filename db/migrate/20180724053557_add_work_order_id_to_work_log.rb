class AddWorkOrderIdToWorkLog < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_logs, :work_order_id, :integer
  	add_column :work_logs, :order_id, :integer
  end
end
