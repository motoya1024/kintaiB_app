Rails.application.routes.draw do

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  resources :users do
    get 'information', on: :member
    patch 'informationupdate', on: :member
  end
  
  resources :timecards 
   
  post '/leavingupdate',  to: 'timecards#leaving_update'
  post '/update_all', to: 'timecards#update_all'
  resources :users do
    member do
      get :following, :followers
    end
  end

  root 'static_pages#home'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
