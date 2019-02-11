class AddColumnToStudents < ActiveRecord::Migration[5.2]
  def change
  	add_column :students, :year, :string, :default => "0",:null=> false
  end
end
