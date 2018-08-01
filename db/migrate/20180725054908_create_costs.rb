class CreateCosts < ActiveRecord::Migration[5.2]
  def change
    create_table :costs do |t|
		t.string :title, null: false
		t.integer :parent_id, default: 0
		t.timestamps
    end
  end
end
