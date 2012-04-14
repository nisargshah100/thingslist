Thingslist::Application.routes.draw do

  devise_for :users
  
  resources :categories
  resources :city, :ads
  
  # Api Paths

  namespace :api do
    resources :categories do
      collection do
        get 'parents'
        get 'children'
      end
    end

    resources :cities do
      collection do
        get 'nearby'
        get 'search'
      end
    end
  end

  root :to => 'home#index'
end
