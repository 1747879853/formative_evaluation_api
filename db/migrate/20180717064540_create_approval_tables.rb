class CreateApprovalTables < ActiveRecord::Migration[5.2]
  def change
    create_table :approvals do |t|
    	t.string :name
    	t.string :en_name_main
    	t.string :en_name_detail
    	t.string :comment
    	t.datetime :created_time
    	t.datetime :stoped_time
    	t.integer :status  # 1 正在使用， 0 停用

    	t.timestamps
    end
    create_table :approval_fields do |t|
    	t.references :approval
    	t.string :name
    	t.string :en_name
    	t.string :control
    	t.string :comment
    	t.string :info
    	t.integer :sequence
    	t.string :selectoptions
    	t.string :dateformat

    	t.timestamps
    	
    end
    create_table :approval_detail_fields do |t|
    	t.references :approval
    	t.string :name
    	t.string :en_name
    	t.string :control
    	t.string :comment
    	t.string :info
    	t.integer :sequence
    	t.string :selectoptions
    	t.string :dateformat
    	
    	t.timestamps
    	
    end

    create_table :procedures do |t|
    	t.references :approval
    	t.string :comment
    	t.datetime :created_time
    	t.datetime :stoped_time
    	t.integer :status  #1 正在使用， 0 停用
    	
    	t.timestamps
    	
    end

    create_table :procedure_nodes do |t|
    	t.references :procedure
    	t.string :name    	
    	t.integer :sequence
    	t.references :owner, polymorphic: true #这里对应某个角色
    	
    	t.timestamps
    	
    end
  end
end

