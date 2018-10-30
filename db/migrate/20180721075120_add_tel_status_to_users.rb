class AddTelStatusToUsers < ActiveRecord::Migration[5.2]
  def change
	add_column :users, :username, :string
	add_column :users, :email, :string
	add_column :users, :password_digest, :string
	add_column :users, :last_login, :datetime
	add_column :users, :status, :string
  end
end
