Rails.application.routes.draw do
  get 'home/index'
  get 'do_or_die', to: 'home#do_or_die', as: :do_or_die
  get 'join_group', to: 'home#join_group', as: :join_group

  resources :comments, only: :create
  resources :weekly_reports, except: :index
  patch 'groups/approve_request', to: 'groups#approve_request'
  resources :groups
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    patch 'users/requests_to_belong', to: 'users/registrations#requests_to_belong'
  end
  get 'groups/:id/requests', to: 'groups#requests_index', as: :groups_requests
  get 'groups/:group_id/weekly_reports', to: 'weekly_reports#group_index', as: :groups_weekly_reports
  get 'users/:user_id/weekly_reports', to: 'weekly_reports#user_index', as: :users_weekly_reports

  post 'weekly_reports/preview', to: 'weekly_reports#preview'

  root to: 'home#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
