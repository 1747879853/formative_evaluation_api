class CreateSummary < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
    	t.date :date,null: false
  		t.string :address
  		t.text :workcontent
  		t.string :transport
  		t.text :explain
      t.bigint :uid
  		t.timestamps
    end
  end
end
