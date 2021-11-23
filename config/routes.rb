Rails.application.routes.draw do
  resources :scores
  resources :race_results
  resources :tracks
  resources :races
  resources :drivers
  resources :points_allocations
  resources :points_systems
  resources :seasons
  resources :championships
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
