class AddWorkShopTaskIdToWorkTeamTasks < ActiveRecord::Migration[5.2]
  def change
    add_reference :work_team_tasks, :work_shop_task, index: true
  end
end
