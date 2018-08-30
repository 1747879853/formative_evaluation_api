class RenameWorkTeamxTasksColumns < ActiveRecord::Migration[5.2]
  def change
  	rename_column :work_teamx_tasks, :work_shop_tasks_id , :work_shop_task_id 
  	rename_column :work_teamx_tasks, :type , :p_type 
  end
end
