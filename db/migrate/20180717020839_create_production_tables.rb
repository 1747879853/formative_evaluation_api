class CreateProductionTables < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
    	t.string :no
    	t.string :title
    	t.string :client_title
    	t.datetime :record_time

    	t.timestamps

    end
    create_table :work_orders do |t|
    	t.integer :number
    	t.string :title
    	t.string :type
    	t.string :maker
    	t.references :order
    	t.integer :status
    	t.datetime :record_time

    	t.timestamps

    end

    create_table :materials do |t|
    	t.integer :number
    	t.string :graph_no
    	t.string :name
    	t.string :comment
    	t.references :work_order

    	t.timestamps

    end
    create_table :boms do |t|
    	t.integer :number
    	t.integer :total
    	t.string :name
    	t.string :spec
    	t.decimal :length
    	t.decimal :width
    	t.string :comment
    	t.references :material

    	t.timestamps
    end
  end
end
