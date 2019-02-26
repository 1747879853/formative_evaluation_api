class DeleteEnoAndTermFromEvaluations < ActiveRecord::Migration[5.2]
  def change
  	remove_column :evaluations, :eno
  	remove_column :evaluations, :term
  end
end
