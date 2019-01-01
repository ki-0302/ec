Rails.application.routes.draw do
  namespace :admin do
    resources :admin_users
  end

  root to: 'admin/admin_users#index'
end
