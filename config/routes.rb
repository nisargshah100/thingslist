Thingslist::Application.routes.draw do
  devise_for :users
  resources :categories

  namespace :api do
    resources :categories, :only => [:index]
  end

  root :to => 'home#index'
end
