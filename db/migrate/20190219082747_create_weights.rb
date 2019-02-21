class CreateWeights < ActiveRecord::Migration[5.2]
  def change
    create_table :weights do |t|
      t.references :courses
      t.references :evaluations
      t.string :weight, default: ''
    end
  end
end
