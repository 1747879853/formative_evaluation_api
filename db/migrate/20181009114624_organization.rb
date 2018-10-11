class Organization < ActiveRecord::Migration[5.2]
  def change
  	create_table :organizations do |t|
      t.string :name
      t.integer :parent_id
      t.timestamps null: false
    end
  end
end
