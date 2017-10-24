Rails.application.routes.draw do
  resources :likes
  resources :suggestions
  resources :outings
  resources :users, only: [:new, :create, :show]

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  root 'users#show'
end
