class AddComentToWorkOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :work_orders, :comment, :string
  end
end
