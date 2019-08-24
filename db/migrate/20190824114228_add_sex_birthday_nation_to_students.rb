class AddSexBirthdayNationToStudents < ActiveRecord::Migration[5.2]
  def change
  	add_column :students, :sex, :string, :default => "0"
  	add_column :students, :birthday, :string, :default => "0"
  	add_column :students, :nation, :string, :default => "0"
  end
end
