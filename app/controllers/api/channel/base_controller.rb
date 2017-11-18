class Api::Channel::BaseController < ActionController::API
  include ::ActionView::Layouts
  include ActionSearchable

  respond_to :json
  layout "api"

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include Api::DeviceDetectable
  include Api::Channel::Authenticateable
  include Api::Channel::Rescueable
end
