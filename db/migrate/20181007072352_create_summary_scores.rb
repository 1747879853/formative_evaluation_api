class CreateSummaryScores < ActiveRecord::Migration[5.2]
  def change
    create_table :summary_scores do |t|
    	t.references :summary
    	t.datetime :score_time
    	t.references :user
    	t.references :job_item_content
    	t.string :score
    	t.decimal :score_total 
    end
  end
end
