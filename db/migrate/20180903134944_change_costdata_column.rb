class ChangeCostdataColumn < ActiveRecord::Migration[5.2]
  def change
  	# ALTER TABLE costdata ALTER money TYPE integer USING money::integer
  	change_column :costdata, :money, 'integer USING CAST(money AS integer)'
  end
  # def up
  #   ALTER TABLE costdata ALTER money TYPE integer USING money::int;
  # end
 
end
