Rails.application.routes.draw do
  devise_for :users

  namespace :account do
    resources :favorites do
      member do
        post :favorite
        post :dislikes
      end
    end
    resources :orders do
      member do
        get :pay
        post :cancel
        post :make_payment
        post :apply_for_cancel
        post :confirm_receipt
        post :apply_for_return
      end
    end
    resources :addresses do
      member do
        post :set_default
      end
    end
  end

  namespace :admin do
    resources :orders do
      member do
        post :confirm_cancel
        post :ship
        post :confirm_goods_returned
      end
    end
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
