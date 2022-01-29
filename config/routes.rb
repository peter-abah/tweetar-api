Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'authentication#create'
      post 'register', to: 'users#create'

      resources :tweets, except: %i[edit new]
      get 'tweets/:id/replies', to: 'tweets#replies'
    end
  end
end
