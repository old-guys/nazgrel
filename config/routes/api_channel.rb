namespace :api, defaults: { format: :json } do
  namespace :channel do
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
end
