class Api::ZmallMobile::PingController < Api::ZmallMobile::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/zmall_mobile/ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end