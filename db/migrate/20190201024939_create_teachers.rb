class CreateTeachers < ActiveRecord::Migration[5.2]
  def change
    create_table :teachers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :tno, null: false, unique: true
      t.string :tel, null: false, default: ""
      t.string :status, null: false, default: "1"
      t.timestamps
    end
  end
end
