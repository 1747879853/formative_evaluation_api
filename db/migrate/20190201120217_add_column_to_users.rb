class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :owner_id, :integer, :default => 0,:null=> false
   	add_column :users, :owner_type, :string, :default => "0",:null=> false
  end
end
