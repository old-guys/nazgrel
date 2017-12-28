namespace :dev do
  namespace :report do
    root :to => 'dashboard#index'

    resources :shops
    resources :shop_activities
  end
end