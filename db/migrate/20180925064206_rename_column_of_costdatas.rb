class RenameColumnOfCostdatas < ActiveRecord::Migration[5.2]
  def change

    rename_column :costdata, :summaries_id, :summary_id
    rename_column :costdata, :name, :names
    add_column :costdata, :costids, :string

  end
end
