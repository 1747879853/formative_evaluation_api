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
      get    '/authRuleList'   =>  'authorities#index'
      post   '/authRuleList'   =>  'authorities#add'

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
