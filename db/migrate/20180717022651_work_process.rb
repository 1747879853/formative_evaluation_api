class WorkProcess < ActiveRecord::Migration[5.2]
  def change
  	create_table :work_logs do |t|
		t.references :owner, polymorphic: true, index: true
		t.datetime :record_time
		t.text :description

    	t.timestamps

  	end

    create_table :work_shop_tasks do |t|
    	t.references :work_shop
    	t.references :work_order
    	t.references :user
    	t.datetime :record_time
    	t.integer :status

    	t.timestamps

    end
    create_table :work_team_tasks do |t|
    	t.references :work_team
    	t.references :material
    	t.references :user
    	t.datetime :record_time
    	t.integer :status

    	t.integer :number
    	t.integer :finished_number
    	t.integer :passed_number

    	t.timestamps

    end
    create_table :work_team_task_details do |t|
    	t.references :work_team_task
    	t.references :user
    	t.datetime :record_time

    	t.integer :finished_number
    	t.integer :passed_number

    	t.timestamps

    end
    create_table :boms_approvals do |t|
    	t.references :work_team_task
    	t.references :user
    	t.datetime :record_time

		t.references :approval_owner, references: :users
    	t.datetime :approval_time
    	t.string :approval_comment

    	t.integer :status

    end
    create_table :boms_approval_details do |t|
    	t.references :boms_approval
    	t.references :bom

    	t.integer :approval_number
    	t.integer :real_number

    end

  end
end
