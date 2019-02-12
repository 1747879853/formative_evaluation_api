class CreateTeachersClassesCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers_classes_courses do |t|
      t.references :teachers
      t.references :class_rooms
      t.references :courses
    end
  end
end
