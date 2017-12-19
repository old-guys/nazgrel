class Api::Channel::AuthController < Api::Channel::BaseController
  skip_before_action :authenticate!, only: [:login], raise: false

  def login
    raise AuthError.new("账号不能为空") if params[:login].blank?

    login_field = params[:login].include?("@") ? :email : :phone
    @channel_user = ChannelUser.with_database_authentication(login_field => params[:login]).first
    @channel = @channel_user.try(:channel)
    @channel_region = @channel_user.try(:channel_region)

    if @channel_user && @channel_user.valid_password?(params[:password])
      if @channel_user.try(:deleted?)
        raise Errors::UserAuthenticationError.new("该用户已经被删除")
      end

      if @channel_user.try(:access_locked?)
        raise Errors::UserAuthenticationError.new("该用户已经被冻结")
      end

      if @channel_user.region_manager?
        if not @channel_region.try(:normal?)
          raise Errors::UserAuthenticationError.new("该用户的渠道管理是无效的")
        end
      else
        unless @channel
          raise Errors::UserAuthenticationError.new("该用户的渠道是无效的")
        end
        unless @channel.normal?
          raise Errors::UserAuthenticationError.new("该用户的渠道已经被冻结")
        end
      end

      @channel_user.update(last_sign_in_at: @channel_user.current_sign_in_at, current_sign_in_at: Time.now)
      @api_key = @channel_user.api_key
    else
      raise Errors::AuthError.new("帐号或者密码错误")
    end

    @message = "success"
    @remark = "成功"
  end

  def ping
    render 'api/channel/ping/index', layout: false
  end
end