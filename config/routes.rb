Urlagg::Application.routes.draw do
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout, :method => :post
  match '/tags/top' => 'tags#top'
  match '/tags/:tag' => 'tags#show', :constraints => { :tag => /\D.+/ }

  resources :tags do
    collection do
      get :top
    end
    member do
      get :summary
      post :read
    end
  end

  resource :user_session
  resource :account
  resources :users do

    member do
      get :summary
    end

  end

  resources :password_resets
  resources :taggings
  match 'pages/:id' => 'pages#show', :id => 'index'
  
  namespace :admin do
    match 'dashboard' => 'dashboard#index', :as => :dashboard
    match 'login' => 'super_user_sessions#new', :as => :login
    match 'logout' => 'super_user_sessions#destroy', :as => :logout, :method => :post
    resource :super_user_session
    resources :links do
      collection do
        get :reports
      end
    end
    resources :tags
    resources :users
  end

  root :to => 'pages#show', :index => 'index'
end
