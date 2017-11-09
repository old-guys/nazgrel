class ApplicationController < ActionController::API
  include ::ActionView::Layouts

  respond_to :json
  layout "application"

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include DeviceDetectable
  include Authenticateable
  include Rescueable
end
