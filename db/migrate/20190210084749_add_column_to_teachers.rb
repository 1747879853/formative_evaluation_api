class AddColumnToTeachers < ActiveRecord::Migration[5.2]
  def change
  	add_column :teachers, :year, :string, :default => "0",:null=> false
  end
end
