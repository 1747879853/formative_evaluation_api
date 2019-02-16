class AddParentIdWeightToEvaluations < ActiveRecord::Migration[5.2]
  def change
  	add_column :evaluations, :parent_id, :integer, :default => 0
  	add_column :evaluations, :weight, :float, :default => 1.0
  end
end
