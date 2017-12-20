class Api::Dev::PingController < Api::Dev::BaseController
  skip_before_action :authenticate!, raise: false

  def index
    render 'api/dev/ping/index', layout: false
  end
end