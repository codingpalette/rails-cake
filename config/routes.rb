Rails.application.routes.draw do
  resources :registrations, only: [:new, :create]
  resources :bakeries, only: [:new, :create, :show] do
    resources :menu_items, only: [:create, :destroy]
    resources :notes do
      member do
        patch 'toggle_public'
      end
    end
    post 'toggle_favorite', to: 'favorites#toggle'
    get 'stories', to: 'stories#index'
  end
  resources :favorites, only: [:index]
  resources :all_notes, only: [:index]
  resource :session
  resource :user, only: [:edit, :update]
  resources :passwords, param: :token
  get "home/index"
  
  # Admin setup route (for initial admin creation)
  resource :admin_setup, controller: 'admin_setup', only: [:new, :create]

  # Admin routes
  namespace :admin do
    root "admin#dashboard"
    get "users", to: "admin#users"
    patch "users/:id/toggle_admin", to: "admin#toggle_admin", as: :toggle_admin
    resources :bakeries, only: [:index, :edit, :update, :destroy]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"


  root to: "home#index"
end
