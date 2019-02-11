class CreateJoinTableCoursesTeachers < ActiveRecord::Migration[5.2]
  def change
  	create_join_table :courses, :teachers, table_name: :courses_teachers
  end
end
