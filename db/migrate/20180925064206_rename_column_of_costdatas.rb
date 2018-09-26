class RenameColumnOfCostdatas < ActiveRecord::Migration[5.2]
  def change
  	
    # add_column :schedules, :type, :integer, default: 0
    # rename_column :schedules, :type, :schedule_type
    rename_column :costdata, :summaries_id, :summary_id
    add_column :costdata, :item_third_id, :integer
  end
end
