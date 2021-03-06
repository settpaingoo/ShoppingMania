ShoppingMania::Application.routes.draw do
  #review routes
  get "auth/facebook/callback" => "sessions#create"

  resource :session, only: [:new, :create, :destroy]
  resources :users, except: [:index, :destroy] do
    collection do
      get "activate" => "users#activate"
      get "reset_password" => "users#reset_password"
      post "reset_password" => "users#send_password_token"
      put "reset_password" => "users#update_password"

      resources :addresses, only: [:index, :create, :edit, :update, :destroy]
      resources :carts, only: :show
      resources :orders, only: [:index, :new, :create, :show]
      resources :wishlists, only: [:index, :create, :destroy]
    end
  end

  resources :items do
    collection do
      put "admin/edit" => "items#admin_shortcut"
    end

    resources :cart_items, only: :create
    resources :saved_items, only: :create
    resources :wishlist_items, only: :create
    resources :reviews, only: :create
  end

  resources :cart_items, only: [:update, :destroy]
  resources :saved_items, only: :destroy
  resources :wishlist_items, only: :destroy
  resources :photos, only: :destroy

  root to: "items#index"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
