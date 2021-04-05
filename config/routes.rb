Rails.application.routes.draw do
  resources :stocks

  root 'home#index'

  namespace :api do
    namespace :v1 do
      resources :stocks, params: [:symbol, :exchangeName]
      resources :stock_prices, only: [:create]
    end
  end
  
  get '*path' => 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
