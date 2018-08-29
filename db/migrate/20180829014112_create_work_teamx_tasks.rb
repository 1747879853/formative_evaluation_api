class CreateWorkTeamxTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :work_teamx_tasks do |t|
      t.references :work_shop_tasks
      t.integer :assigner_id
      t.integer :type
      t.integer :status

      t.timestamps
    end
  end
end
