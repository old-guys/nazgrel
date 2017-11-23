class Api::Channel::DashboardController < Api::Channel::BaseController

  def index
    @result = {
      today: {
        shop_count: current_channel_user.today_shop_count,
        order_count: current_channel_user.today_order_count,
      },
      shop_count: current_channel_user.shop_count,
      order_count: current_channel_user.order_count,
      commission_amount: current_channel_user.commission_amount
    }
  end
end
