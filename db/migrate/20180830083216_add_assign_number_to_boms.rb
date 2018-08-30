class AddAssignNumberToBoms < ActiveRecord::Migration[5.2]
  def change
    add_column :boms, :assign_number, :integer ,:default => 0
    add_column :boms, :passed_number, :integer ,:default => 0
  end
end
