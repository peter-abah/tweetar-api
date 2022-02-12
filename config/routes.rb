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

      resources :feed, only: [:index]

      resources :tweets, except: %i[edit new] do
        resource :retweets, only: %i[create destroy]
        resource :likes, only: %i[create destroy]
      end

      resources :retweets, only: %i[index show]
      resources :likes, only: %i[index show]

      get 'tweets/:id/replies', to: 'tweets#replies'

      post 'follow', to: 'follows#create'
      delete 'follow', to: 'follows#destroy'
    end
  end
end
