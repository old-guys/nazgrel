namespace :dev do
  namespace :report do
    root :to => 'dashboard#index'

    resources :shops
    resources :shop_activities
    resources :city_shop_activities

    resources :shopkeepers, only: [:index] do
      collection do
        get :tree
      end
    end
  end
end