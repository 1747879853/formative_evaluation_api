class CreateApproval20180718152612s < ActiveRecord::Migration[5.2]
  def change
    create_table :approval20180718152612s do |t|
      t.string :field0
      t.text :field1
      t.string :field2
      t.string :field3
      t.datetime :field4

      t.timestamps
    end
  end
end
