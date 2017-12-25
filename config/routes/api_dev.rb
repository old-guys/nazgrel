namespace :api, defaults: { format: :json } do
  namespace :dev do
    resources :ping, only: [:index] do
    end

    resources :seeks, only: [:index] do
      collection do
        get :sync, :sync_shop, :sync_channel
      end
    end
  end
end