SCA::Application.routes.draw do
  
  resources :users, :slider_images
  resources :sessions, only: [:new, :create, :destroy]
  resources :faqs do
    collection { post :import }
  end
  resources :products
  resources :features
  
  get "home", to: 'slider_images#index', as: 'home'
  get "forums", to: "static_pages#forums", as: 'forums'
  get "reviews", to: "static_pages#reviews", as: 'reviews'
  get "support", to: "static_pages#support", as: 'support'
  get "tips", to: "static_pages#tips", as: 'tips'
  get "troubleshooting", to: "static_pages#troubleshooting", as: 'troubleshooting'
  get "repairs", to: "static_pages#repairs", as: 'repairs'
  get "resources", to: "static_pages#resources", as: 'resources'
  get "contact", to: "static_pages#contact", as: 'contact'
  get "order", to: "static_pages#cart", as: 'cart'
  get "signup", to: 'users#new', as: 'signup'
  get "signin", to: 'sessions#new', as: 'signin'
  delete "signout", to: 'sessions#destroy', as: 'signout'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'slider_images#index'

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
