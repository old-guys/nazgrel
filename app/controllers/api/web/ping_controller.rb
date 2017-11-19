class Api::Web::PingController < Api::Web::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/web/ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end
