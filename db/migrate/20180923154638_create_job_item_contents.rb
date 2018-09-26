class CreateJobItemContents < ActiveRecord::Migration[5.2]
  def change
    create_table :job_item_contents do |t|
    	t.references :auth_group

    	t.string   :item_title
    	t.decimal  :item_weight, precision: 8, scale: 2
    	
    	# t.string  :item_standard_titles
    	# t.string  :item_standard_proportions
    	t.string  :item_stds  #save standards and proportions of job item,eg: std1,0.7;std2,0.3

    	# t.string :content_titles
    	# t.string :content_standards
    	t.string :item_cnts  #save contents of job item, every contents has many standards and proportions,eg: cnt1-std1,std2;cnt2-std1,std3,cnt3-std4,std5
    	t.timestamps
    end
  end
end


