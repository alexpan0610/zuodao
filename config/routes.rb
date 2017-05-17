Rails.application.routes.draw do
  devise_for :users

  namespace :account do
    resources :orders do
      member do
        get :pay
        post :make_payment
      end
    end
    resources :addresses do
      member do
        post :set_default
      end
    end
  end

  namespace :admin do
    resources :orders
    resources :categories
    resources :products
    resources :users
  end

  resources :products do
    member do
      post :operations
    end
  end

  resources :carts do
    member do
      post :operations
      get :checkout
    end
  end

  resources :cart_items do
    member do
      post :increase
      post :decrease
    end
  end

  root "welcome#index"
end
