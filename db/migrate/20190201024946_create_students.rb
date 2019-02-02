class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :sno, null: false, unique: true
      t.string :tel, null: false, default: ""
      t.integer :class_room_id, null: false, default: 0
      t.string :status, null: false, default: "1"
      t.timestamps
    end
  end
end
