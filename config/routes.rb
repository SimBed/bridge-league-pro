Rails.application.routes.draw do
  resources :matches, except: [:show] do
    get 'filter', on: :collection
  end
  resources :leagues
  resources :players
  root "matches#index"
end
