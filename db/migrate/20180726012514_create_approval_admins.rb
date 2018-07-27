class CreateApprovalAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :approval_admins do |t|
    	t.string :name
    	t.string :comment
    	t.datetime :created_time
    	t.integer :status  # 1 正在使用， 0 停用

    	t.timestamps
    end
  end
end
