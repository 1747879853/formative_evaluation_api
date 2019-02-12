class AddColumnTeachersClassesCourses < ActiveRecord::Migration[5.2]
  def change
  	add_column :teachers_classes_courses, :term, :string, :default => "",:null=> false
  end
end
