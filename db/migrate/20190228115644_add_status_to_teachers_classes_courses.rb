class AddStatusToTeachersClassesCourses < ActiveRecord::Migration[5.2]
  def change
  	add_column :teachers_classes_courses, :status, :integer, :default => 0,:null=> false
  end
end
