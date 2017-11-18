module Api::Channel::Authenticateable
  # controller and view
  extend ActiveSupport::Concern

  included do
    helper_method :version_code
  end

  private
  def authenticate_app!
    raise Errors::InvalidAppError.new("device参数错误") unless device.in?(%w(ios android h5 pc))
  end

  def authenticate!
    unless current_channel_user
      change_reason = "您的登录已经过期，请重新登录！"

      logger.error "invalid user_token, auth_params #{auth_params}"
      raise Errors::UserAuthenticationError.new(change_reason)
    end

    if current_channel_user.try(:deleted?)
      raise Errors::UserAuthenticationError.new("该用户已经被删除")
    end

    RequestStore.store[:current_channel_user] = current_channel_user
    RequestStore.store[:current_channel] = current_channel_user.try(:channel)

    @current_channel_user = RequestStore.store[:current_channel_user]
    @current_channel = RequestStore.store[:current_channel]
  end

  def current_channel_user
    return @current_channel_user if defined?(@current_channel_user)
    token = ApiKey.find_by(access_token: auth_params[:user_token])
    if token
      @current_channel_user = ChannelUser.find_by(id: token.user_id)
    end
  end

  def current_channel
    @current_channel ||= -> {
      current_channel_user.try(:channel)
      RequestStore.store[:current_channel] = current_channel_user.try(:channel)
    }.call
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
