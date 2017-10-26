Rails.application.routes.draw do
  get 'errors/not_found'

  get 'errors/internal_server_error'
  
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

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
  post '/outings/:id/submit', to:'outings#submit_suggestions', as: 'submit_suggestions'

  get '/outings/:id/vote', to:'outings#vote', as: 'vote'

  get '/outings/:id/result', to:'outings#result', as: 'result'

  get '/logout', to: 'sessions#destroy'
end
