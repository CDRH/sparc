Rails.application.routes.draw do
  devise_for :users
  resources :features do
    as_routes
    record_select_routes
    add_as_extension :features
  end

  resources :room_types do
    as_routes
    record_select_routes
    add_as_extension :room_types
  end

  resources :bone_tools do
    as_routes
    record_select_routes
    add_as_extension :bone_tools
  end

  resources :eggshells do
    as_routes
    record_select_routes
    add_as_extension :eggshells
  end

  resources :units do
    as_routes
    record_select_routes
    add_as_extension :units
  end

  resources :strata do
    as_routes
    record_select_routes
    add_as_extension :strata
  end

  resources :ornaments do
    as_routes
    record_select_routes
    add_as_extension :ornaments
  end

  resources :soils do
    as_routes
    record_select_routes
    add_as_extension :soils
  end

  resources :perishables do
    as_routes
    record_select_routes
    add_as_extension :perishables
  end

  resources :select_artifacts do
    as_routes
    record_select_routes
    add_as_extension :select_artifacts
  end

  # activescaffold_extensions(:rooms)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'units#index'

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
