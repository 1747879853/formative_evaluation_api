class AddStatusToWorkTeams < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_teams, :status, :string, :default => "1",:null=> false
  end
end
