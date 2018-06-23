class CreateAuthGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_groups do |t|
      t.string :title, null: false, unique: true
      t.integer :status, null: false, default: 1

      t.timestamps
    end

    create_join_table :auth_groups, :auth_rules, table_name: :auth_groups_rules
    create_join_table :users, :auth_groups, table_name: :auth_groups_users
  end
end
