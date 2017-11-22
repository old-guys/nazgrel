class Api::Channel::ChannelUsersController < Api::Channel::BaseController

  def my
    @channel_user = current_channel_user
  end
end
