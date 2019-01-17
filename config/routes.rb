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

  root to: 'admin/admin_users#index'
end
