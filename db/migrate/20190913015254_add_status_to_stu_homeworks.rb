class AddStatusToStuHomeworks < ActiveRecord::Migration[5.2]
  def change
  	add_column :stu_homeworks, :status, :integer, :default => 0
  end
end
