Rails.application.routes.draw do
  root "items#index"
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  resources :items, only: [:index, :show]
  resources :carts, only: [:index, :create, :update, :destroy]
  resources :orders, only: [:index, :show, :new, :create] do
    member do
      get :confirm
      post :confirmed
      get :result
    end
  end
  namespace :admin do
    resources :items
  end
end
