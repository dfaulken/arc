Rails.application.routes.draw do
  devise_for :mods
  root to: 'championships#index'

  resources :championships
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
  resources :races
  resources :seasons do
    member do
      post :recalculate_all
    end
  end
  resources :tracks
end
