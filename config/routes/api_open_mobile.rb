namespace :api, defaults: { format: :json } do
  scope '/open' do
    namespace :mobile, module: "open_mobile" do
      resources :ping, only: [:index] do
        collection do
          get :ping_db
        end
      end

      resources :dashboard, only: [:index] do
        collection do
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
end