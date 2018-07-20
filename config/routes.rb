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
      get    '/users'          => 'users#index'
      get    '/users/current'  => 'users#current'
      post   '/users/create'   => 'users#create'
      patch  '/user/:id'       => 'users#update'
      delete '/user/:id'       => 'users#destroy'
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
      # Order actions
      get    '/orders'         => 'orders#order_list'
      get    '/order_details'  => 'orders#order_details' 
      get    '/xialiao'        => 'orders#xialiao' 
      get    '/zupin'          => 'orders#zupin' 
      get    '/work_order_details' => 'orders#work_order_details' 

      post   '/work_shop_task' => 'orders#work_shop_task_add'
      get    '/work_shop_order_list' => 'orders#work_shop_order_list'
      get    '/teams'  => 'orders#work_teams'

      post   '/work_team_task' => 'orders#work_team_task_add'
      get    '/work_team_task_list' => 'orders#work_team_task_list'
      get    '/team_task_boms' => 'orders#team_task_boms'

      post   '/team_task_material_finished' => 'orders#team_task_material_finished'
      post   '/team_task_material_passed'   => 'orders#team_task_material_passed'
      # WorkOrder actions
      
      # Approval actions
      get '/approval_list'   =>'approval#approval_list'
      post '/approval_create'   =>'approval#approval_create'
      get '/approval_field_list' =>'approval#approval_field_list'

      # Procedure actions
      get '/procedure_nodes'   =>'procedure#procedure_nodes'
      post '/procedure_create' =>'procedure#procedure_create'

    end
  end

end
