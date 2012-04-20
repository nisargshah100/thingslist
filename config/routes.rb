Thingslist::Application.routes.draw do
  get 'users/sign_in' => redirect('/users/auth/facebook')
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :categories
  resources :ads
  
  resources :city do
    collection do
      get 'search'
    end
  end
  
  get 'redirect' => 'home#redirect'

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
