class CreateClassRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :class_rooms do |t|
      t.string :name, null: false
      t.string :year, null: false
      t.string :clno, null: false, unique: true
      t.integer :status, null: false, default: 1
      t.timestamps
    end
  end
end
