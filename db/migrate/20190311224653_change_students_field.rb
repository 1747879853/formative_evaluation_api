class ChangeStudentsField < ActiveRecord::Migration[5.2]
  def change
  	change_column :students, :name, :string, :default => 'name'
  	change_column :students, :email, :string, :default => 'email@email'
  end
end
