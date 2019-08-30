class AddColumnToStuHomeworks < ActiveRecord::Migration[5.2]
  def change
  	add_column :stu_homeworks, :tea_comment, :string
  end
end
