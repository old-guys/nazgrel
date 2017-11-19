namespace :api, defaults: { format: :json } do
  namespace :web do
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

    resources :constant_setting, only: [:index] do
      collection do
        get :enum_field
      end
    end

    resources :channels
  end
end
