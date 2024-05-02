Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :v1 do
    post 'users/log_in', to: 'users#log_in'
    post 'users/sign_up', to: 'users#sign_up'

    post 'credentials', to: 'credentials#index'

    namespace :user do
      resources :institutions, only: [:index, :create] do
        resources :roles, only: [:index]
        resources :events, only: [:index, :show] do
          resources :credential_events, except: [:show]
        end
      end     
    end
  end
end
