class Api::Channel::DashboardController < Api::Channel::BaseController

  def index
    @result = {
      today: {
        shop_count: @current_channel.today_shop_count,
        order_count: @current_channel.today_order_count,
      },
      shop_count: @current_channel.shop_count,
      order_count: @current_channel.order_count,
      commission_amount: @current_channel.commission_amount
    }
  end
end
