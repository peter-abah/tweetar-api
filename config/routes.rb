Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'authentication#create'
      post 'register', to: 'users#create'

      resources :users, except: %i[edit new] do
        member do
          get 'followers'
          get 'followed_users'
        end
      end
      
      resources :tweets, except: %i[edit new]
      resources :retweets, except: %i[edit new update]
      resources :likes, except: %i[edit new update]
      resources :feed, only: [:index]
      get 'tweets/:id/replies', to: 'tweets#replies'

      post 'follow', to: 'follows#create'
      delete 'follow', to: 'follows#destroy'
    end
  end
end
