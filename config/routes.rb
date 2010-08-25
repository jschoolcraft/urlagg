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
  resources :taggings, :only => [:create, :destroy]
  match 'pages/:id' => 'pages#show', :id => 'index'  
  root :to => 'pages#show', :index => 'index'
end
