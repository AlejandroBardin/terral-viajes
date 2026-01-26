Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  namespace :admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"
    resources :packages
    resources :settings do
      delete "disconnect_meta", on: :collection
    end
    resource :pixel, only: [ :show, :update ]
    resources :leads, only: [ :index, :show ]
  end
  namespace :api do
    scope "webhooks" do
      # Meta Webhook (GET=Verify, POST=Receive)
      match "meta", to: "meta/webhooks#handle", via: [ :get, :post ]
      post "chatwoot", to: "webhooks#chatwoot"
    end
  end

  namespace :auth do
    get "meta/callback", to: "meta#callback"
    post "meta/save_page", to: "meta#save_page"
  end
end
