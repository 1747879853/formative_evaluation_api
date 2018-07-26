class AddStatusToWorkShops < ActiveRecord::Migration[5.2]
  def change
  	add_column :work_shops, :status, :string, :default => "1",:null=> false
  end
end
