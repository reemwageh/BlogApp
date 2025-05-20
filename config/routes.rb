Rails.application.routes.draw do
  # User routes
  post '/signup', to: 'users#signup'
  post '/login', to: 'users#login'

  resources :posts, only: [:index, :show, :create, :update, :destroy]
  resources :tags, only: [:index, :show, :create, :update, :destroy]
  resources :comments , only: [:create, :update, :destroy]
end
