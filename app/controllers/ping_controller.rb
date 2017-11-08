class PingController < ApplicationController
  skip_before_action :authenticate!, raise: false

  def index
  end

  def ping_db
    @user = User.last
  end
end
