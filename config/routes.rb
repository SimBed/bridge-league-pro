Rails.application.routes.draw do
  resources :matches, except: [:show]
  resources :leagues
  resources :players
  root "players#index"
end
