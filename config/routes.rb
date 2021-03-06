Rails.application.routes.draw do
  root to: "dashboard#index"

  devise_for :users
  resources :users, except: [:destroy, :show]
  resources :genres, except: [:show]
  resources :authors, except: [:show]
  resources :books, except: [:show] do
    member do
      patch :toggle_featured
    end
  end
end
