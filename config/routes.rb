Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

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

  # Health and PWA routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end