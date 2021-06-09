Rails.application.routes.draw do
  root to: 'keywords#index'

  devise_for :users

  resources :keywords, only: :index
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
