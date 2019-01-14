Rails.application.routes.draw do
  namespace :admin do
    get 'products/new'
    get 'products/edit'
    get 'products/show'
    get 'products/index'
  end
  namespace :admin do
    resources :admin_users
    resources :categories
    resources :tax_classes
    resources :tax_items
  end

  root to: 'admin/admin_users#index'
end
