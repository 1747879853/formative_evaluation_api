class AlterEvaluations < ActiveRecord::Migration[5.2]
  def change
  	remove_column :evaluations, :eno
  	remove_column :evaluations, :weight
    add_column :evaluations, :eno, :string, null: false, default:''
    add_column :evaluations, :term, :string
  end
end
