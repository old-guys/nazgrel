class Api::Web::BaseController < ActionController::API
  include ::ActionView::Layouts
  include ActionController::Caching

  respond_to :json
  layout "api"

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include Api::DeviceDetectable
  include Api::Web::Authenticateable
  include Api::Web::Rescueable
end