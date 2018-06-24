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

      # Order actions
      get    '/orders'          => 'orders#index'
      # WorkOrder actions
      # 
    end
  end

end
