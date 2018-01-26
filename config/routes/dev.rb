namespace :dev do
  namespace :report do
    root :to => 'dashboard#index'

    resources :shops, only: [:index]
    resources :shop_activities, only: [:index]
    resources :city_shop_activities, only: [:index]
    resources :cumulative_shop_activities, only: [:index]

    resources :shop_ecns

    resources :orders, only: [:index] do
      collection do
        get :sales
      end
    end

    resources :shopkeepers, only: [:index] do
      collection do
        get :tree
      end
    end
  end
end