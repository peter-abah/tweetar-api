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
            get 'recommended_follows', to: 'follows#recommended'
            post 'follow', to: 'follows#create'
            delete 'follow', to: 'follows#destroy'
          end

          resources :retweets, only: :index
          resources :likes, only: :index
        end

        resources :feed, only: [:index]

        resources :tweets, except: %i[edit new] do
          resource :retweets, only: %i[create destroy]
          resource :likes, only: %i[create destroy]

          resources :retweets, :likes, only: :index
          get 'replies', member: true
        end

        resources :bookmarks, only: %i[index create destroy]

        resources :likes, :retweets, only: :show
      end
    end
  end
end
