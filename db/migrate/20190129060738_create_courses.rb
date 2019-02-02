class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.string :cno, null: false, unique: true
      t.integer :status, null: false, default: 1
      t.timestamps
    end
  end
end
