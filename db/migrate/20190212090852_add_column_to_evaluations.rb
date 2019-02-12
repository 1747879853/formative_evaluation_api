class AddColumnToEvaluations < ActiveRecord::Migration[5.2]
  def change
  	add_column :evaluations, :description, :string, :default => ""
  end
end
