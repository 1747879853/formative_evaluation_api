class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
    	t.string :name
    	t.integer :parent_id, default: 0
    	t.timestamps
    end
    create_table :region_users do |t|    	
    	t.belongs_to :user, index: true
      t.belongs_to :region, index: true
    	t.timestamps
    end
  end
end
