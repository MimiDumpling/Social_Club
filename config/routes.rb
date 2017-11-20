Rails.application.routes.draw do
  get 'plans/index'

  get 'plans/:id', to: 'plans#show'

  post 'plans', to: 'plans#create'

  get 'registration/index'

  resources :users

  root 'registration#index'

  post 'payments', to: 'payments#create'

  get 'logout', to: 'logout#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
