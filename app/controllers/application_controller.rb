class ApplicationController < ActionController::API
  respond_to :json

  before_action :authenticate_app!, :authenticate!

  include ActionController::HttpAuthentication::Token
  include DeviceDetectable
  include Authenticateable
  include Rescueable
end
