Rails.application.routes.draw do
  root to: 'keywords#index'

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users

  resources :keywords, only: :index

  resources :users, only: %i[create]

  namespace :api do
    namespace :v1 do
      # User sign_up
      resources :users, only: %i[create]

      # OAuth2 (token, revoke, ...)
      use_doorkeeper do
        controllers tokens: 'tokens'

        skip_controllers :applications, :authorizations, :authorized_applications, :token_info
      end
    end
  end
end
