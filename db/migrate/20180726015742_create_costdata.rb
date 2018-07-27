class CreateCostdata < ActiveRecord::Migration[5.2]
  def change
    create_table :costdata do |t|
    	t.string :name, null: false
    	t.text :thing
    	t.string :money, null: false
    	t.bigint :summary_id, null: false
		t.timestamps
    end
  end
end
