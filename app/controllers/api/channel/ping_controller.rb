class Api::Channel::PingController < Api::Channel::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/channel/ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end
