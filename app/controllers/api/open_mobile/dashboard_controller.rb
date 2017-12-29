class Api::OpenMobile::DashboardController < Api::OpenMobile::BaseController
  def index
    date = Date.today
    _raw_result = Rails.cache.fetch("open_mobile:dashboard:#{date.to_s}:index", raw: true, expires_in: 5.minutes) {
      {
        date: Date.today,
        shop_count: Shop.where(created_at: date.to_time.all_day).size,
        order_count: Order.sales_order.valided_order.where(
          created_at: date.to_time.all_day
        ).size,
        order_amount: Order.sales_order.valided_order.where(
          created_at: date.to_time.all_day
        ).sum(:total_price)
      }.to_yaml
    }

    @result = YAML.load(_raw_result)
  end

  def hot_sales_product
    @result = {
      today: current_channel_user.today_hot_sales_product
    }
  end
end