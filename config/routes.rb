Thingslist::Application.routes.draw do
  devise_for :users
  
  resources :categories
  resources :ads
  
  resources :city do
    collection do
      get 'search'
    end
  end

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

    resources :ads do
    end
  end

  root :to => 'home#index'
end
