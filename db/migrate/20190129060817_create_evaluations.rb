class CreateEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluations do |t|
      t.string :name, null: false
      t.string :types, null: false
      t.string :eno, null: false, unique: true
      t.integer :status, null: false, default: 1
      t.timestamps
    end
  end
end
