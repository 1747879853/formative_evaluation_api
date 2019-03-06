class AddTermAndClassRoomsIdToGrades < ActiveRecord::Migration[5.2]
  def change
  	add_column :grades, :term, :string, :default => ""
  	add_column :grades, :class_rooms_id, :integer, :default => 0, :null=> false
  end
end
