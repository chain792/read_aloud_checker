Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create show]
      resources :sentences, only: %i[show] do
        resource :bookmark, only: %i[create destroy]
        collection { get :bookmark }
      end
      resources :user_sentences, only: %i[index]
      resources :news_sentences, only: %i[index]
      namespace :user do
        resources :sentences, only: %i[index create edit update destroy]
        resources :trainings, only: %i[index create show]
        resources :voices, only: %i[create] do
          collection do
            get :presigned_post
            get :presign
          end
        end
        resources :records, only: %i[index]
        resource :listening_sex, only: %i[update]
      end
      resource :profile, only: %i[update] do
        collection { get :presigned_post }
      end
      namespace :profile do
        resource :email, only: %i[update]
        resource :password, only: %i[update]
      end
      resources :password_resets, only: %i[create edit update]
      post 'login', to: 'sessions#create'
      post 'refresh', to: 'sessions#refresh'
      delete 'logout', to: 'sessions#destroy'
      namespace :oauth do
        resource :twitter, only: %i[new] do
          collection { get :callback }
        end
        resource :google, only: %i[new] do
          collection { get :callback }
        end
        resource :yahoo, only: %i[new] do
          collection { get :callback }
        end
      end
      get 'health_check', to: 'health_checks#index'
    end
  end
end
