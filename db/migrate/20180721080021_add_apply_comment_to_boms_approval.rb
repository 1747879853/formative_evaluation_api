class AddApplyCommentToBomsApproval < ActiveRecord::Migration[5.2]
  def change
    add_column :boms_approvals, :apply_comment, :string
  end
end
