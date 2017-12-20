class Api::Dev::BaseController < ActionController::API
  include ::ActionView::Layouts
  include ActionController::Caching

  respond_to :json
  layout "api"

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include Api::DeviceDetectable
  include Api::Dev::Authenticateable
  include Api::Dev::Rescueable
end