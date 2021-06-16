Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users

  root to: 'keywords#index'

  resources :keywords, only: :index

  namespace :api do
    namespace :v1 do
      # User sign_up
      resources :users, only: %i[create]
    end
  end

  scope 'api/v1' do
    # OAuth2 (token, revoke, ...)
    use_doorkeeper do
      skip_controllers :authorizations, :applications, :authorized_applications
    end
  end
end
