Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create]
      resources :sentences, only: %i[show]
      resources :user_sentences, only: %i[index]
      resources :news_sentences, only: %i[index]
      namespace :user do
        resources :sentences, only: %i[create]
      end
      post 'login', to: 'sessions#create'
      post 'refresh', to: 'sessions#refresh'
      delete 'logout', to: 'sessions#destroy'
    end
  end
end
