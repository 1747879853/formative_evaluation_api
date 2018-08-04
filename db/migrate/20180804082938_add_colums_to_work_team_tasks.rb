class AddColumsToWorkTeamTasks < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_team_tasks, :production_status, :integer,:default => 0
  	add_column :work_team_tasks, :current_position, :string
  	add_column :work_team_tasks, :process, :string
  	add_column :work_team_tasks, :finished_process, :string
  end
end
