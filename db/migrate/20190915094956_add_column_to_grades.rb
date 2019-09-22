class AddColumnToGrades < ActiveRecord::Migration[5.2]
  def change
  	add_column :grades, :record_time, :datetime
  end
end
