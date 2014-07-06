Htk::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      # match 'email_comments', to: 'email_comments#index', via: [:get, :post]
      resources :email_comments
      resources :signed_request_users, only: [:create]
      resources :deliverables do
        resources :comments, controller: 'deliverable_comments'
        resources :users, controller: 'deliverable_users', only: [:create, :destroy, :update]
      end
      resources :deliverable_relations
      # resources :emails, :only => :create
      resources :users, only: [:index, :show]
      resources :messages, only: [:index]
      resources :emails, only: [:index]
      resources :deliverable_types, :only => :index
      resources :companies, controller: 'deliverables/companies'
    end
  end 


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, path: "auth"

  resources :email_accounts do
    resources :emails, :controller => 'email_accounts/emails'
  end
  resources :emails, :controller => 'email_accounts/emails', :only => :show
  resources :email_summaries, :controller => 'email_accounts/email_summaries', :only => :index

  resources :messages, :only => [:index, :show, :update, :destroy]
  # resources :message_bodies, :only => [:show]
  resources :users, :only => [:show]
  match 'test_deliverables_gadget', to: 'test_deliverables_gadget#index'

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

  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
