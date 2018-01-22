module Api::Web::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
    helper_method :version_code
  end

  private
  def authenticate_app!
    _devices = %w(pc web)
    raise Errors::InvalidAppError.new("device参数错误") unless device.in?(_devices)
  end

  def authenticate!
    unless current_user
      change_reason = "您的登录已经过期，请重新登录！"

      logger.error "invalid user_token, auth_params #{auth_params}"
      raise Errors::UserAuthenticationError.new(change_reason)
    end

    if current_user.try(:deleted?)
      raise Errors::UserAuthenticationError.new("该用户已经被删除")
    end

    RequestStore.store[:current_user] = current_user
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = User.find_for_access_token(
      access_token: auth_params[:user_token]
    )
  end

  def current_app
    RequestStore.store[:current_app] ||= device
  end

  def auth_params
    @auth_params ||= begin
      token, options = token_and_options(request)
      return params unless options
      options[:user_token] = token
      options
    end
  rescue
    params
  end

  def version_code
    auth_params[:version_code]
  end
end