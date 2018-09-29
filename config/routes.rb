Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Knock::Engine => "/knock"

  # Home controller routes.
  # root   'home#index'
  # get    'auth'            => 'home#auth'
  
  
  namespace :api do
    namespace :v1 do
      # Get login token from Knock
      post   'user_token'      => 'user_token#create'

      # User actions
      get    '/userList'       => 'users#get_userlist'
      get    '/users/current'  => 'users#current'
      get    '/sub_user_list' => 'users#sub_user_list'
      post   '/userList'       => 'users#post_userlist'
      patch  '/userList'       => 'users#patch_userlist'
      delete '/userList'       => 'users#delete_userlist'
      get    '/userpass'       => 'users#get_userpass'
      patch  '/userpass'       => 'users#patch_userpass'
      # resources :users, only: [:index, :current, :create, :update, :destroy]

      # Authority actions
      get    '/authRuleList'   =>  'authorities#get_rulelist'
      post   '/authRuleList'   =>  'authorities#post_rulelist'
      delete '/authRuleList'   =>  'authorities#delete_rulelist'
      patch  '/authRuleList'   =>  'authorities#patch_rulelist'
      
      get    '/user_group_list'=>  'authorities#get_user_group_list'

      get    '/authGroupList'  =>  'authorities#get_grouplist'
      post   '/authGroupList'  =>  'authorities#post_grouplist'
      delete '/authGroupList'  =>  'authorities#delete_grouplist'
      patch  '/authGroupList'  =>  'authorities#patch_grouplist'

      get    '/authUserList'   =>  'authorities#get_userlist'
      patch  '/authUserList'   =>  'authorities#patch_userlist'
      
      # Cost actions
      get    '/costList'       =>  'cost#get_costlist'
      post   '/costList'       =>  'cost#post_costlist'
      delete '/costList'       =>  'cost#delete_costlist'
      patch  '/costList'       =>  'cost#patch_costlist'

      # job item content(jic) actions
      
      get    '/get_current_user_jic' =>  'job_item_content#get_current_user_jic'
      get    '/jicList'       =>  'job_item_content#get_jic_list'
      post   '/jicList'       =>  'job_item_content#post_jic_list'
      delete '/jicList'       =>  'job_item_content#delete_jic_list'
      patch  '/jicList'       =>  'job_item_content#patch_jic_list'

      # Work actions
      get    '/getSummary'       =>  'summary#get_summary'
      get    '/cost_detail' => 'summary#cost_detail'
      get    '/get_summaries'      =>  'summary#get_summaries'
      get    '/get_summaries_s'      =>  'summary#get_summaries_s'
      # get    '/get_summaries_total' =>  'summary#get_summaries_total'
      get    '/costdata_query' => 'costdata#costdata_query'
      get    '/costdata_query_s' => 'costdata#costdata_query_s'
      post   '/saveSummary'       =>  'summary#save_summary'


      # Costdata actions

      # Order actions
      post   '/upload_work_order'         => 'orders#upload_work_order'
      get    '/orders'         => 'orders#order_list'
      post   '/orders'         => 'orders#post_order'
      get    '/order_details'  => 'orders#order_details' 
      get    '/xialiao'        => 'orders#xialiao' 
      get    '/zupin'          => 'orders#zupin' 
      get    '/work_order_details'  => 'orders#work_order_details' 
      post   '/work_order_details'  => 'orders#post_work_order'
      post   '/template'       => 'orders#post_template'
      post   '/work_shop_task' => 'orders#work_shop_task_add'
      get    '/work_shop_order_list' => 'orders#work_shop_order_list'
      get    '/teams'          => 'orders#work_teams'

      post   '/work_team_task' => 'orders#work_team_task_add'
      get    '/work_team_task_list'  => 'orders#work_team_task_list'
      get    '/team_task_boms' => 'orders#team_task_boms'

      post   '/team_task_material_finished' => 'orders#team_task_material_finished'
      post   '/team_task_material_passed'   => 'orders#team_task_material_passed'
      post   '/boms_approval'  => 'orders#boms_approval'
      get    '/boms_approvals' => 'orders#boms_approval_list'
      get    '/boms_approval_detail' => 'orders#boms_approval_detail'
      post   '/auditing_boms'  => 'orders#auditing_boms'
      get    '/order_process'  => 'orders#order_process'
      get    '/team_task_finish' => 'orders#team_task_finish'
      get    '/checking_list'  => 'orders#checking_list'
      get    '/work_logs'      => 'orders#work_logs'
      get    '/work_log_tree'  => 'orders#work_log_tree'
      get    '/workshop_logs'  => 'orders#workshop_logs'
      get    '/xialiao_shoptasks' => 'orders#xialiao_shoptasks'
      post   '/give_task_to_team' => 'orders#give_task_to_team'
      post   '/flow_finished'  =>'orders#flow_finished'
      post   '/zupin_finished' => 'orders#zupin_finished'
      get    '/painting_list'  => 'orders#painting_list'
      post   '/give_painting_team_task' => 'orders#give_painting_team_task'
      post   '/paint_finished' => 'orders#paint_finished'
      get    '/tree_grid_xialiao_task_list' => 'orders#tree_grid_xialiao_task_list'

      get    '/tree_shop_task' => 'orders#tree_shop_task'
      post   '/give_task_teamx'=> 'orders#give_task_teamx'

      post   'xialiao_flow_finished' => 'orders#xialiao_flow_finished'
      get    'xialiao_checking_list' => 'orders#xialiao_checking_list'
      post   'xialiao_passed'  => 'orders#xialiao_passed'

      get    '/work_teams'     => 'orders#get_work_team'
      post   '/work_teams'     => 'orders#post_work_team'
      delete '/work_teams'     => 'orders#delete_work_team'
      patch  '/work_teams'     => 'orders#patch_work_team'

      get    '/work_shops'     => 'orders#get_work_shop'
      post   '/work_shops'     => 'orders#post_work_shop'
      delete '/work_shops'     => 'orders#delete_work_shop'
      patch  '/work_shops'     => 'orders#patch_work_shop'
      # WorkOrder actions

      # images
      post   '/images'         => 'imageupload#upload'
      delete '/images'         => 'imageupload#delete_image'
            
      # Approval actions
      get '/approval_admin_list'   =>'approval#approval_admin_list'
      get '/approval_list'   =>'approval#approval_list'
      get '/approval_list_inuse'   =>'approval#approval_list_inuse'
      post '/approval_create'   =>'approval#approval_create'
      post '/approval_save'   =>'approval#approval_save'
      get '/approval_field_list' =>'approval#approval_field_list'
      get '/approval_field_edit' =>'approval#approval_field_edit'
      get '/approval_to_me'   =>'approval#approval_to_me'
      get '/approval_to_me_done'   =>'approval#approval_to_me_done'
      get '/approval_from_me'   =>'approval#approval_from_me'
      get '/approval_info'   =>'approval#approval_info'
      post '/approval_pass'   =>'approval#approval_pass'
      post '/approval_reject'   =>'approval#approval_reject'
      post '/approval_admin_start'   =>'approval#approval_admin_start'
      post '/approval_admin_stop'   =>'approval#approval_admin_stop'
     

      # Procedure actions
      get '/procedure_nodes'   =>'procedure#procedure_nodes'
      post '/procedure_create' =>'procedure#procedure_create'

      # Vehicle actions
      get  '/vehicleList'   =>'vehicle#get_vehiclelist'
      post '/vehicleList'   =>'vehicle#post_vehiclelist'

      # Employee actions
      get   '/attendanceList'   =>'employee#get_attendanceList'
      post  '/attendanceList'   =>'employee#post_attendanceList'

    end
  end

end
