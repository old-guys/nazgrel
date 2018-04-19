namespace :dev do
  namespace :report do
    root :to => 'dashboard#index'

    resources :shops, only: [:index]
    resources :shop_activities, only: [:index]
    resources :city_shop_activities, only: [:index]
    resources :cumulative_shop_activities, only: [:index]

    resources :cumulative_product_sales_activities, only: [:index]

    resources :daily_operationals, only: [:index]
    resources :daily_shop_grade_operationals, only: [:index]
    resources :daily_operational_shop_grade_summaries, only: [:index]
    resources :operational_cumulative_shop_activity_summaries, only: [:index]
    resources :operational_cumulative_shop_activities, only: [:index]

    resources :shop_retentions, only: [:index]
    resources :product_repurchases, only: [:index]

    resources :shop_ecns

    resources :orders, only: [:index] do
      collection do
        get :sales
      end
    end

    resources :order_details, only: [:index] do
      collection do
        get :sales
      end
    end

    resources :product_skus

    resources :shopkeepers, only: [:index] do
      collection do
        get :tree
      end
    end
  end
end