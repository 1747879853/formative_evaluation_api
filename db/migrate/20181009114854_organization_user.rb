class OrganizationUser < ActiveRecord::Migration[5.2]
  def change
  	create_table :organizations_users do |t|
      t.integer :organization_id
      t.integer :user_id
      t.boolean :leader, default: false

      t.timestamps
    end
  end
end
