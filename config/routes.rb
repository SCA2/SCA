SCA::Application.routes.draw do
  
  resources :slider_images, :users

  resources :faqs_categories, except: [:show]
  resources :faqs, except: [:show]

  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :addresses do    
    collection do
      get 'subregion_options'
    end
  end
  
  resources :carts, only: [:show, :update, :destroy]
  
  resources :products do
    resources :features, except: [:index, :show]
    resources :options, except: [:index, :show]
    member do
      put 'update_option'  
    end
  end

  get 'products/*id', to: 'products#show', format: false

  resources :line_items, only: [:create]

  resources :orders, only: [:index, :show, :update, :destroy] do
    collection do
      get 'subregion_options'
      get 'express'
      get 'create_express'
      get 'search'
      get 'sales_tax'
      delete 'delete_abandoned'
    end
    member do
      get 'addresses'
      post 'create_addresses'
      get 'shipping'
      patch 'update_shipping'
      get 'payment'
      patch 'update_payment'
      get 'confirm'
      patch 'update_confirm'
    end
  end

  resource :checkout, only: :new do
    resource :express,        only: [:new],           controller: 'checkout/express' do
      get 'create'
    end
    resources :addresses,     only: [:new, :create],  controller: 'checkout/addresses'
    resources :subregions,    only: [:new, :create],  controller: 'checkout/subregions'
    resource :shipping,       only: [:new, :update],  controller: 'checkout/shipping'
    resource :confirmation,   only: [:new, :update],  controller: 'checkout/confirmation'
    resource :payment,        only: [:new, :update],  controller: 'checkout/payment'
    resources :transactions,  only: [:new],           controller: 'checkout/transactions'
  end

  root to: "static_pages#home"
  get "home", to: "static_pages#home", as: 'home'
  get "forums", to: "static_pages#forums", as: 'forums'
  get "support", to: "static_pages#support", as: 'support'
  get "tips", to: "static_pages#tips", as: 'tips'
  get "troubleshooting", to: "static_pages#troubleshooting", as: 'troubleshooting'
  get "repairs", to: "static_pages#repairs", as: 'repairs'
  get "resources", to: "static_pages#resources", as: 'resources'
  get "contact", to: "static_pages#contact", as: 'contact'
  get "terms", to: "static_pages#terms", as: 'terms'
  get "privacy", to: "static_pages#privacy", as: 'privacy'
  get "conditions", to: "static_pages#conditions", as: 'conditions'
  get "admin", to: "static_pages#admin", as: "admin"

  get "password_resets/new"
  get "signup", to: 'users#new', as: 'signup'
  get "signin", to: 'sessions#new', as: 'signin'
  delete "signout", to: 'sessions#destroy', as: 'signout'
  match "features", to: 'features#create', via: :post

  get "*id", via: :all, to: "error_pages#unknown"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
