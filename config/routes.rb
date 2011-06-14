ActionController::Routing::Routes.draw do |map|

  map.resources :locations
  map.resources :examples
  map.resources :users
  map.resources :kinds
  map.resources :vips

  map.resources :assets , :collection =>{ :autocomplete_for_tag_name => :get, :tags => :get } do |assets|
   assets.resources :roles
  end

  map.resources :cobbler_sync_jobs
  map.resources :physical_machines, :member => {:guests => :get,
                                                :deep_clone => :get}
  map.resources :virtual_machines, :member => {:parent => :get, 
                                               :deep_clone => :get}

  map.resources :models
  map.resources :manufacturers
  map.resources :roles
  map.resources :interfaces, :collection => { :autocomplete_for_tag_name => :get, 
                                              :autocomplete_for_interface_ip => :get,
                                              :test_if_used => :get }


  map.resource :user_session
  map.resource :account, :controller => "users"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.clone_asset 'assets/:id/clone', :controller => 'assets', :action => 'clone', :as => 'clone'
  map.dns_asset 'assets/:id/dns', :controller => 'assets', :action => 'dns', :as => 'dns'
  map.live_search 'assets/live_search/:searching', :controller=> 'assets', :action => 'live_search', :as => 'live_search'

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "assets"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
