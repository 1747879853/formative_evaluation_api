class WorkShops < ActiveRecord::Migration[5.2]
  def change
    create_table :work_shops do |t|
    	t.string :name
    	t.string :type
    	t.references :user

    	t.timestamps

    end
    create_table :work_teams do |t|
    	t.string :name
    	t.references :work_shop
    	t.references :user

    	t.timestamps

    end

  end
end
