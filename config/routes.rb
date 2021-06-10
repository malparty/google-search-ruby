Rails.application.routes.draw do
  root to: 'keywords#index'

  devise_for :users #authentication
  resources :keywords, only: :index
end
