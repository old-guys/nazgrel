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
          get :user_grade_stat, :children_rank
          get :city_rank, :order_amount_rank
        end
      end

      resources :shopkeepers, only: [:index] do
        collection do
          get :sales, :report
        end
      end
      resources :shops, only: [:index] do
        member do
          get :summary, :children_rank, :city_rank
          get :stat, :report
        end
      end

      resources :shop_activities, only: [:show] do
        collection do
          get :view_count_rank, :shared_count_rank, :viewer_count_rank
        end
        member do
          get :summary
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