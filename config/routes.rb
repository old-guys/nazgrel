Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :ping, only: [:index] do
    collection do
      get :ping_db
    end
  end

  resources :auth, only: [] do
    collection do
      post :login
      get :ping
    end
  end
end
