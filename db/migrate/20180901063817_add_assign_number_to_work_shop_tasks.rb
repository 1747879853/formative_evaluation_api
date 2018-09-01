class AddAssignNumberToWorkShopTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :work_shop_tasks, :assign_number, :integer,:default => 0   
  end
end
