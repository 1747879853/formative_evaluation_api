Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Knock::Engine => "/knock"

  # Home controller routes.
  # root   'home#index'
  # get    'auth'            => 'home#auth'
  
  # Get login token from Knock
  post   'user_token'      => 'user_token#create'
  
  namespace :api do
    namespace :v1 do
      # User actions
      get    '/userList'       => 'users#get_userlist'
      get    '/users/current'  => 'users#current'
      post   '/userList'       => 'users#post_userlist'
      patch  '/userList'       => 'users#patch_userlist'
      delete '/userList'       => 'users#delete_userlist'
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
      patch   '/costList'       =>  'cost#patch_costlist'

      # Order actions
      get    '/orders'         => 'orders#order_list'
      get    '/order_details'  => 'orders#order_details' 
      get    '/xialiao'        => 'orders#xialiao' 
      get    '/zupin'          => 'orders#zupin' 
      get    '/work_order_details' => 'orders#work_order_details' 

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
      # WorkOrder actions
      
      # Approval actions
      get '/approval_list'   =>'approval#approval_list'
      get '/approval_list_inuse'   =>'approval#approval_list_inuse'
      post '/approval_create'   =>'approval#approval_create'
      post '/approval_save'   =>'approval#approval_save'
      get '/approval_field_list' =>'approval#approval_field_list'
      get '/approval_to_me'   =>'approval#approval_to_me'
      get '/approval_to_me_done'   =>'approval#approval_to_me_done'
      get '/approval_from_me'   =>'approval#approval_from_me'
      get '/approval_info'   =>'approval#approval_info'
      post '/approval_pass'   =>'approval#approval_pass'
      post '/approval_reject'   =>'approval#approval_reject'
      post '/approval_start'   =>'approval#approval_start'
      post '/approval_stop'   =>'approval#approval_stop'
     

      # Procedure actions
      get '/procedure_nodes'   =>'procedure#procedure_nodes'
      post '/procedure_create' =>'procedure#procedure_create'

    end
  end

end
