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