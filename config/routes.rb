Rails.application.routes.draw do
  root to: "users#index"

  devise_for :users
  resources :users, except: [:destroy, :show]

  resources :books, except: [:show]
end
