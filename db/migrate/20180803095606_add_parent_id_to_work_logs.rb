class AddParentIdToWorkLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :work_logs, :parent_id, :integer
  end
end
