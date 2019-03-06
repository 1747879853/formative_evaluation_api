class AddColumnStatusCreateTimeToWeights < ActiveRecord::Migration[5.2]
  def change
  	# add_column :weights, :status, :integer, null: false, default: 1
  	add_column :weights, :create_time, :datetime
  end
end
