Rails.application.routes.draw do
  get "users/show"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :users, only: [:show]

  get "home/index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"


  resources :cashflows
  root to: "home#index"


  resources :keywords
  resources :membership
  resources :groups do
    member do
      post "join"
    end
  end

  resources :groups
  resources :groups do
    get "cashflow", on: :member
  end

  resources :groups do
    post 'add_member', on: :member
  end

  get "group_cashflow", to: "groups#group_cashflow", as: :group_cashflow

  post "import_records", to: "cashflows#import"



end