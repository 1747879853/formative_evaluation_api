class AddColumnInClassToEvaluations < ActiveRecord::Migration[5.2]
  def change
  	add_column :evaluations, :in_class, :integer, :default => 1,:null=> false
  end
end
