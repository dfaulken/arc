Rails.application.routes.draw do
  resources :teams
  resources :incident_outcomes
  resources :incidents
  devise_for :mods
  root to: 'championships#index'

  resources :championships do
    member do
      post :deregister_driver
      get  :register_driver
      post :register_driver
    end
  end
  resources :drivers do
    collection do
      get  :numbers
    end
  end
  resources :mods, only: %i[ destroy index ] do
    member do
      post :approve
    end
  end
  resources :points_allocations
  resources :points_systems
  resources :race_results do
    collection do
      get  :record
      post :record
      post :delete_all
    end
  end
  resources :races do
    member do
      post :publish_incident_outcomes
    end
  end
  resources :seasons do
    member do
      post :recalculate_all
      get  :projection
    end
  end
  resources :tracks
end
