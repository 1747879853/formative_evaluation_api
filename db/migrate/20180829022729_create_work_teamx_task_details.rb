class CreateWorkTeamxTaskDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :work_teamx_task_details do |t|
      t.belongs_to :work_teamx_task
      t.belongs_to :bom
      t.integer :number
      t.integer :finished_number
      t.integer :passed_number
      t.string :current_position
      t.string :process
      t.string :finished_process
      t.integer :status
      t.integer :repeat_number,:default => 0

      t.timestamps
    end
  end
end
