class AddColumnToStuHomeworkExcellent < ActiveRecord::Migration[5.2]
  def change
    add_column :stu_homeworks, :excellent, :boolean
  end
end
