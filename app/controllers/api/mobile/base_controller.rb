class Api::Mobile::BaseController < ActionController::API
  include ::ActionView::Layouts

  respond_to :json
  layout "api"

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include Api::DeviceDetectable
  include Api::Mobile::Authenticateable
  include Api::Mobile::Rescueable
end
