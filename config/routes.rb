Rails.application.routes.draw do
  root to: 'keywords#index'

  use_doorkeeper do
    skip_controllers :authorizations, :authorized_applications, :tokens, :token_info
  end

  devise_for :users, controllers: { registrations: :registrations }

  resources :keywords, only: [:index, :create, :show]

  resources :filters, only: :index

  resources :preview, only: :show

  resources :users, only: :create

  namespace :api do
    namespace :v1 do
      # User sign_up
      resources :users, only: :create

      resources :keywords, only: [:index, :create, :show]

      # OAuth2 (token, revoke, ...)
      use_doorkeeper do
        controllers tokens: 'tokens'

        skip_controllers :applications, :authorizations, :authorized_applications, :token_info
      end
    end
  end
end
