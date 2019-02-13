class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades do |t|
      t.references :students
      t.references :evaluations
      t.references :courses
      t.string :grade, default: ''
    end
  end
end
