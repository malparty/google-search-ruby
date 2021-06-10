Rails.application.routes.draw do
  root to: 'keywords#index'

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users

  resources :keywords, only: :index

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create]
    end
  end
end
