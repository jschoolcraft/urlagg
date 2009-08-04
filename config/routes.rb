ActionController::Routing::Routes.draw do |map|
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy", :method => :post
  
  map.connect '/tags/top', :controller => 'tags', :action => 'top'
  map.connect '/tags/:tag', :controller => 'tags', :action => 'show', :requirements => {:tag => /\D.+/} 
  map.resources :tags, :member => { :summary => :get, :read => :post }, :collection => { :top => :get }
  
  map.resource :user_session
  map.resource :account
  map.resources :users, :member => { :summary => :get }
  map.resources :password_resets
  map.resources :taggings
  
  map.connect   'pages/:id', :controller => 'pages', :action => 'show'
  map.namespace :admin do |admin|
    admin.dashboard 'dashboard', :controller => 'dashboard'
    admin.login 'login', :controller => 'super_user_sessions', :action => "new"
    admin.logout 'logout', :controller => "super_user_sessions", :action => "destroy", :method => :post
    admin.resource :super_user_session
    admin.resources :links, :collection => { :reports => :get }
    admin.resources :tags
    admin.resources :users
  end
  
  map.root :controller => "pages", :action => "show", :index => 'index'
end
