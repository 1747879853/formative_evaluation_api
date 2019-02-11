class CreateJoinTableCoursesEvaluations < ActiveRecord::Migration[5.2]
  def change
  	create_join_table :courses, :evaluations, table_name: :courses_evaluations
  end
end
