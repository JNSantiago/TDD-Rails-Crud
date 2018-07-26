Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'User', at: 'auth', base_controller: 'Api::V1::ApiController'
  
  resources :products

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :create, :update, :destroy]
    end
  end
end
