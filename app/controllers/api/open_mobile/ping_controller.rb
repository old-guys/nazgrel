class Api::OpenMobile::PingController < Api::OpenMobile::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/open_mobile/ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end