Rails.application.routes.draw do
  namespace :admin do
    resources :admin_users
    resources :categories
    resources :tax_classes
    resources :tax_items
    resources :products
  end

  root to: 'admin/admin_users#index'
end
