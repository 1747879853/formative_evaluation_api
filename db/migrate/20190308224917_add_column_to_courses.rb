class AddColumnToCourses < ActiveRecord::Migration[5.2]
  def change
  	add_column :courses, :brief, :text
  	add_column :courses, :outline_name, :string
  	add_column :courses, :outline_url, :string
  end
end
