class Api::Mobile::PingController < Api::Mobile::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/mobile/ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end
