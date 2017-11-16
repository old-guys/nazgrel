class Api::Channel::AuthController < Api::Channel::BaseController
  skip_before_action :authenticate!, only: [:login], raise: false

  def login
    raise AuthError.new("账号不能为空") if params[:login].blank?

    login_field = params[:login].include?("@") ? :email : :phone
    @channel_user = ChannelUser.with_database_authentication(login_field => params[:login]).first

    if @channel_user && @channel_user.valid_password?(params[:password])
      raise Errors::AuthLockError.new("你的帐号已被冻结") if @channel_user.access_locked?
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
