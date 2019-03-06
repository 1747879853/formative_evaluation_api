class AddStatusToWeights < ActiveRecord::Migration[5.2]
  def change
  	add_column :weights, :status, :integer, :default => 1,:null=> false
  end
end
