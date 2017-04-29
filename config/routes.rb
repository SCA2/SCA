SCA::Application.routes.draw do
  
  resources :slider_images, :users

  resources :faqs_categories, except: [:show]
  resources :product_categories, except: [:show]
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
    collection do
      get 'update_category_sort_order'
    end
  end

  resources :boms do
    collection do
      get 'update_option'
    end
    member do
      get 'new_item'
      put 'create_item'
    end
  end
  resources :bom_importers, only: [:new, :create] do
    collection do
      get 'update_option'
    end
  end

  resources :components, except: :show
  resources :component_imports, only: [:index, :new, :create]

  get 'products/*id', to: 'products#show', format: false

  resources :line_items, only: [:create]

  resources :orders, only: [:index, :show, :update, :destroy] do
    collection do
      get 'successful'
      get 'failed'
      get 'pending'
      get 'shipped'
      delete 'delete_abandoned'
      get 'sales_tax'
      get 'search'
    end
    member do
      get 'get_tracking_number'
      patch 'send_tracking_number'
    end
  end

  resources :checkout, only: [] do
    resource :express,        only: [:new, :edit],          controller: 'checkout/express'
    resources :addresses,     only: [:new, :create],        controller: 'checkout/addresses'
    resource :shipping,       only: [:new, :update],        controller: 'checkout/shipping'
    resource :payment,        only: [:new, :update],        controller: 'checkout/payment'
    resource :confirmation,   only: [:new, :update],        controller: 'checkout/confirmation'
    resources :transactions,  only: [:new, :update],        controller: 'checkout/transactions'
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

end
