Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :stripe do
    resources :checkout_sessions, only: [:create]
    resources :customer_portals, only: [:create]
    resource :success_checkouts, only: [:show]
    resource :cancelled_checkouts, only: [:show]
    resource :webhooks, only: [:create]
  end

  root to: 'home#index'
end
