class AddTelStatusToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :tel, :string, :default => "",:null=> false
   	add_column :users, :status, :string, :default => "1",:null=> false
  end
end
