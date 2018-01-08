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

    resources :channel_regions do
      collection do
        delete :destroy_channel
      end
    end

    resources :channels
    resources :channel_users

    resources :shopkeepers, only: [] do
      collection do
        get :check
      end
    end

    namespace :report do
      resources :channel_shop_newers, only: [:index] do
        collection do
          get :report
        end
      end

      resources :channel_shop_activities, only: [:index] do
        collection do
          get :report
        end
      end
    end
  end
end