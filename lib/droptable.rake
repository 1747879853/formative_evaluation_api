namespace :droptable do
  desc 'auto delete table created by auto form'
  task :delete_form_table => :environment do
    Approval.all.each do |app|
      ActiveRecord::Migration.drop_table app.en_name_detail.classify.constantize.table_name
      ActiveRecord::Migration.drop_table app.en_name_main.classify.constantize.table_name
      app.delete
    end    

  end
end