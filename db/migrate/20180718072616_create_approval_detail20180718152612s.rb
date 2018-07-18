class CreateApprovalDetail20180718152612s < ActiveRecord::Migration[5.2]
  def change
    create_table :approval_detail20180718152612s do |t|
      t.string :field0
      t.string :field1
      t.integer :approval20180718152612_id

      t.timestamps
    end
  end
end
