class CreateTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms do |t|
      t.string :name, null: false
      t.date :begin_time, null: false
      t.date :end_time, null: false
    end
  end
end
