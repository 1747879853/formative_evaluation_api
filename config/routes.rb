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
      get    '/first_subuser_list' => 'users#first_subuser_list'
      get    '/all_subuser_me_list' => 'users#all_subuser_me_list'
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

      # Teacher actions
      get        '/teacherList'    =>  'teachers#get_teacherlist'
      post       '/teacherList'    =>  'teachers#post_teacherlist'
      patch      '/teacherList'    =>  'teachers#patch_teacherlist'
      delete     '/teacherList'    =>  'teachers#delete_teacherlist'
    end
  end

end
