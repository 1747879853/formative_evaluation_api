class CreateJoinTableClassRoomsCourses < ActiveRecord::Migration[5.2]
  def change
  	create_join_table :class_rooms, :courses, table_name: :class_rooms_courses
  end
end
