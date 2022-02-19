Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post 'login', to: 'authentication#create'
        post 'register', to: 'users#create'

        resources :users, except: %i[edit new] do
          member do
            get 'followers'
            get 'followed_users'
            post 'follow', to: 'follows#create'
            delete 'follow', to: 'follows#destroy'
          end
        end

        resources :feed, only: [:index]

        resources :tweets, except: %i[edit new] do
          resource :retweets, only: %i[create destroy]
          resource :likes, only: %i[create destroy]
          get 'replies', to: 'tweets#replies', member: true
        end

        resources :retweets, only: %i[index show]
        resources :likes, only: %i[index show]
      end
    end
  end
end
