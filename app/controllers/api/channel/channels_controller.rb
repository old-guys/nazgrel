class Api::Channel::ChannelsController < Api::Channel::BaseController

  def my
    @channel = current_channel
  end
end
