Rails.application.routes.draw do
  root to: "users#index"

  devise_for :users
  resources :users, except: [:destroy, :show]

  devise_for :books
  resources :books, except: [:destroy, :show]

  resources :books
end
