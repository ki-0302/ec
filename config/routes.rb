Rails.application.routes.draw do
  namespace :admin do
    resources :admin_users
    resources :categories
    resources :tax_classes
    resources :tax_items
    resources :products
    resources :tax_rates
    resources :general_settings, only: %i[edit update]
    namespace :contents do
      resources :slideshows
    end
  end

  namespace :api do
    resources :products, only: %i[index]
  end

  get '/', to: 'fronts#index'
  get '/:name', to: 'fronts#show'

  root to: 'fronts#index'
end
