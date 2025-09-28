# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :users, only: %i[index show create] do
    collection do
      post :follow
      delete :unfollow
      get ':id/followers', to: 'users#followers'
      get ':id/following', to: 'users#following'
      get ':id/following/sleep_records', to: 'users#following_sleep_records'
    end
  end

  resources :sleep_records, only: [:index] do
    collection do
      post :clock_in
      post :clock_out
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
