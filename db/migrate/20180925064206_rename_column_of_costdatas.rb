class RenameColumnOfCostdatas < ActiveRecord::Migration[5.2]
  def change

    remove_column :costdata, :summary_id
    # add_column :costdata, :summary_id, :bigint
    add_reference :costdata, :summary, index: true

    rename_column :costdata, :name, :names
    add_column :costdata, :costids, :string

  end
end
