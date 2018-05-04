class Export::Dev::DailyOperationalService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
         total_shopkeeper_count shopkeeper_count activation_shopkeeper_count
         activation_shopkeeper_rate view_count viewer_count shared_count
         order_total_price order_count
         income_coin use_coin
         order_pay_price order_conversion_rate
         sale_order_total_price sale_order_total_price_rate
         shopkeeper_order_total_price shopkeeper_order_total_price_rate
         create_shop_order_total_price
         order_total_price_avg commission_income_amount
         activity_ticket_amount product_cost withdraw_amount
    )
  end

  def report_head_names
    %w(
      # 报表日期
      累计店主数 店主数 有订单店主数
      有订单店主比例 浏览量 访客数 分享数
      订单总额 订单数
      芝蚂币收入 芝蚂币使用
      支付金额 订单转化率
      销售订单总额 销售订单总额占比
      自购订单总额 自购订单总额占比
      开店订单总额
      平均每单金额 佣金
      现金券 成本 提现金额
    )
  end
end
