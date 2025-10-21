# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post :sign_up, to: 'registrations#create'
        post :sign_in, to: 'sessions#create'
        delete :sign_out, to: 'sessions#destroy'
        post :refresh, to: 'refresh#create'
        post :forgot_password, to: 'passwords#create'
        post :reset_password, to: 'passwords#update'
      end

      resources :users
      resources :addresses do
        member do
          patch :set_default
        end
      end
      resources :categories do
        resources :products, only: :index
      end
      resources :products do
        resources :reviews, only: %i[index create]
        resources :variants, only: %i[index create update destroy]
        resources :product_images, only: %i[index create destroy]
      end
      resources :cart_items, path: 'cart', only: %i[index create update destroy]
      resources :orders do
        member do
          post :cancel
          post :complete
          post :ship
        end
        resources :payments, only: %i[index create]
      end
      resources :payments, only: %i[index show]
      resources :coupons, only: %i[index show] do
        collection do
          post :apply
        end
      end
      resources :reviews, only: %i[index show update destroy]
      resources :blog_posts
      resources :banners

      namespace :admin do
        get :dashboard, to: 'dashboard#show'
        resources :reports, only: :index
      end

      get 'docs', to: 'docs#index'
      get 'docs/v1/swagger.yaml', to: 'docs#swagger_yaml'
    end
  end
end
