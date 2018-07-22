class CreateCurrentNodesAndDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :approval_current_nodes do |t|
    	t.string :node_ids
    	t.references :procedure_node  #node id now
    	t.references :user   #submit to user's id
    	t.integer :status  # 0: undone ,1:done and passed, 2: done,rejected
    	t.references :owner, polymorphic: true, index: true



    end
    create_table :approval_details do |t|
    	t.references :procedure_node  #node id now
    	t.references :user   #submit to user's id
    	t.string :action_str  #value : 'agree' or 'reject',maybe chinese
    	t.string :comment
    	t.datetime :action_time
    	t.references :owner, polymorphic: true, index: true
    end
  end
end
