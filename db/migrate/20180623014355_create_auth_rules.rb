class CreateAuthRules < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_rules do |t|
      t.string :name, null: false, index: true, unique: true
      t.string :title, null: false, unique: true
      t.integer :status, null: false, default: 1
      t.text :condition
      t.integer :parent_id, default: 0
      t.timestamps
    end
  end
end
