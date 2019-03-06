class CreateTeaHomeworks < ActiveRecord::Migration[5.2]
  def change
    create_table :tea_homeworks do |t|
      t.string :name, null: false
      t.string :demand, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :courses
      t.references :evaluations
      t.references :teachers
      t.string :term, null: false
      t.timestamps
    end
  end
end
