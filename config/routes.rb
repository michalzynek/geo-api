# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  resources :geolocations
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get 'status', to: 'rails/health#show', as: :rails_health_check

      resources :geolocations, only: %i[index create show destroy]
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
