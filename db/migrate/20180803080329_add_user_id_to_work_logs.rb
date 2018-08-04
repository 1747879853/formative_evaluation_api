class AddUserIdToWorkLogs < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_logs, :user_id, :integer #分配人员id
  	add_column :work_logs, :passed_number, :decimal, precision: 3, scale: 2
  	add_column :work_logs, :number, :decimal, precision: 3, scale: 2
  end
end
