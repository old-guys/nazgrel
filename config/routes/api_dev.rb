namespace :api, defaults: { format: :json } do
  namespace :dev do
    resources :ping, only: [:index] do
    end
  end
end