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
  resource :users, only: [:show] do
    get :profile
    post :update_profile
    get :delivery
    post :update_delivery
  end
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
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end
end
