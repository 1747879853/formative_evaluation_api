class AddReciverToWorkShopTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :work_shop_tasks, :reciver, :integer
  end
end
