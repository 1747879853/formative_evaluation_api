class CreateSummary < ActiveRecord::Migration[5.2]
  def change
    create_table :summaries do |t|
    	t.date :date,null: false, index: true, unique: true
  		t.string :address
  		t.text :workcontent
  		t.string :transport
  		t.text :explain
  		t.timestamps
    end
  end
end

