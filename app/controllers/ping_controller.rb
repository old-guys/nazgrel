class PingController < ApplicationController
  skip_before_action :authenticate!, raise: false

  def index
    render 'ping/index', layout: false
  end

  def ping_db
    @user = User.last
  end
end
