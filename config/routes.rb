Rails.application.routes.draw do
  # Admin authentication and panel
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Customer authentication (Rubric 3.1.4)
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Public product pages
  root 'products#index'

  resources :products, only: [:index, :show] do
    collection do
      get :category
    end
  end

  # Shopping cart routes (Rubric 3.1.1, 3.1.2)
  resource :cart, only: [:show], controller: 'cart' do
    post :add, on: :collection
    delete :remove, on: :member
    patch :update_quantity, on: :member
    delete :clear, on: :collection
  end

  # Checkout and orders (Rubric 3.1.3, 3.3.2)
  resources :orders, only: [:new, :create, :index] do
    get :confirmation, on: :member
  end

  # User account pages (Rubric 3.2.1)
  namespace :account do
    get "addresses/index"
    get "addresses/new"
    get "addresses/edit"
    get "addresses/create"
    get "addresses/update"
    get "addresses/destroy"
    get "orders/index"
    get "orders/show"
    get "dashboard/index"
    root 'dashboard#index'
    resources :orders, only: [:index, :show]
    resources :addresses
  end

  # Health and PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end