Rails.application.routes.draw do
  namespace :admin do
    resources :admin_users
    resources :categories
  end

  root to: 'admin/admin_users#index'
end
