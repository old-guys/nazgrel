class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  draw :api_web
  draw :api_mobile
  draw :api_channel

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "sidekiqadmin" && password == "5529d99a"
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'
end
