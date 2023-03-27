Rails.application.routes.draw do
  resources :matches
  resources :leagues
  resources :players
  root "players#index"
end
