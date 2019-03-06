class CreateExcelTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :excel_templates do |t|
    	t.string :file_used_by
    	t.string :file_name
    	t.string :file_path
    	t.datetime :upload_time
    	t.timestamps
    end
  end
end
