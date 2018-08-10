class AddPaintToWorkTeamTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :work_team_tasks, :paint, :integer,default:0
    add_column :work_team_tasks, :paint_team, :integer
  end
end
