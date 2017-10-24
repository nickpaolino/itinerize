Rails.application.routes.draw do
  resources :likes
  resources :suggestions
  resources :outings
  resources :users, only: [:new, :create, :show]

  root 'welcome#home'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'
end
