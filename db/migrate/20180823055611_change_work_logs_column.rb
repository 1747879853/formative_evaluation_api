class ChangeWorkLogsColumn < ActiveRecord::Migration[5.2]
  def up
    change_column :work_logs, :number, :decimal, :precision => 8, :scale => 2
    change_column :work_logs, :passed_number, :decimal, :precision => 8, :scale => 2
  end
 
  def down
    change_column :work_logs,  :number, :decimal
    change_column :work_logs,  :passed_number, :decimal
  end
end
