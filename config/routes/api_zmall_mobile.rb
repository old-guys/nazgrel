namespace :api, defaults: { format: :json } do
  scope '/zmall' do
    namespace :mobile, module: "zmall_mobile" do
      resources :ping, only: [:index] do
        collection do
          get :ping_db
        end
      end

      resources :shops, only: [:index] do
        member do
          get :summary, :stat
        end
      end
    end
  end
end