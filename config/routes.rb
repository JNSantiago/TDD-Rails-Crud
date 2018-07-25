Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  
  resources :products

  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :create]
    end
  end
end
