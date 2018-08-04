class AddGetUserIdToWorkLogs < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_logs, :get_user_id, :integer #接收人员id
  end
end
