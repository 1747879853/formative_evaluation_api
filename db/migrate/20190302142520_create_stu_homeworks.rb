class CreateStuHomeworks < ActiveRecord::Migration[5.2]
  def change
    create_table :stu_homeworks do |t|
      t.references :students
      t.references :tea_homeworks
      t.datetime :finish_time, null: false
      t.string :content
      t.timestamps
    end
  end
end
