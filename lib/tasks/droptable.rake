namespace :auto_form do
	desc 'auto delete table created by auto form'
	task :delFormData => :environment do
		ApprovalAdmin.all.each do |appadmin|
			apps = appadmin.approvals
		    apps.each do |app|
		    	app.approval_fields.delete_all
		    	app.approval_detail_fields.delete_all
		    	app.procedures.delete_all
			    	if app.en_name_detail && app.en_name_detail.classify.safe_constantize
						ActiveRecord::Migration.drop_table app.en_name_detail.classify.safe_constantize.table_name
					end
					if app.en_name_main && app.en_name_main.classify.safe_constantize
						ActiveRecord::Migration.drop_table app.en_name_main.classify.safe_constantize.table_name
					end
				
				app.delete
		    end 
		    appadmin.delete
		end
		system("rm -f app/models/approval2018*.rb")
		system("rm -f app/models/approval_detail*.rb")
		system("rm -f db/migrate/*_create_approval2018*s.rb")
		system("rm -f db/migrate/*_create_approval_detail2018*s.rb")
	end	
end