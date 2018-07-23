class AddColToApprovalCurrentNodes < ActiveRecord::Migration[5.2]
  def change
  	add_column :approval_current_nodes ,:submit_user_id ,:integer
  end
end
