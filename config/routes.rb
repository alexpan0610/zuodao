Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :orders
    resources :categories
    resources :products
    resources :users
  end

  resources :products

  root "welcome#index"
end
