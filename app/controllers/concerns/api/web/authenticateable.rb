module Api::Web::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
    DEVICES = %w(pc web)
  end

  private
  def authenticate_app!
    raise Errors::InvalidAppError.new("device参数错误") unless device.in?(DEVICES)
  end

  def authenticate!
    unless current_user
      change_reason = "您的登录已经过期，请重新登录！"

      logger.error "invalid user_token, auth_params #{auth_params}"
      raise Errors::UserAuthenticationError.new(change_reason)
    end

    RequestStore.store[:current_user] = current_user
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_for_access_token(
      access_token: auth_params[:user_token]
    )
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