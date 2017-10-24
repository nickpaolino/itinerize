Rails.application.routes.draw do
  resources :likes
  resources :suggestions
  resources :outings
  resources :users, only: [:new, :create, :show]

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  root 'users#show'

  get '/outings/:id/invite', to: 'outings#invite', as: 'invite'
  post '/outings/:id/invite', to: 'outings#send_invites'

  get '/outings/:id/suggest', to:'outings#suggest', as: 'suggest'
  post '/outings/:id/suggest', to:'outings#post_suggestion', as: 'post_suggestion'
  
end
