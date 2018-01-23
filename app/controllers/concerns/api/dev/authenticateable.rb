module Api::Dev::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
  end

  private
  def authenticate_app!
  end

  def authenticate!
  end

  def auth_params
    @auth_params ||= proc {
      token, options = token_and_options(request)
      return params unless options
      options[:user_token] = token
      options
    }.call
  end

  def version_code
    auth_params[:version_code]
  end
end