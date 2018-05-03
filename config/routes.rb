Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "posts#index"

  resources :posts do
    resources :replies, except: [:index, :new, :show]
  end

  resources :users, only: [:show, :edit, :update]


  namespace :admin do
    root "users#index"

    resources :users, only: [:index, :edit, :update]
    resources :categories
  end
end
