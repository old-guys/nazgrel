module Api::OpenMobile::Authenticateable
  # controller and view
  extend ActiveSupport::Concern
  DEVICES = %w(ios android h5)

  included do
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

    if not current_user.try(:open_manager?)
      raise Errors::UserAuthenticationError.new("未授权用户")
    end

    if current_user.try(:access_locked?)
      raise Errors::UserAuthenticationError.new("该用户已经被冻结")
    end
  end

  def current_user
    RequestStore.store[:current_user] ||= User.find_for_access_token(
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