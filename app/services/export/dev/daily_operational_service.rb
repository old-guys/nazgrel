class Export::Dev::DailyOperationalService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
      total_shopkeeper_count shopkeeper_count activation_shopkeeper_count
      activation_shopkeeper_rate view_count viewer_count shared_count
      order_total_price order_count order_pay_price order_conversion_rate
      order_total_price_avg commission_income_amount
      activity_ticket_amount product_cost
    )
  end

  def report_head_names
    %w(
      # 报表日期
      累计店主数 店主数 活跃店主数
      活跃店主比例 浏览量 访客数 访客数
      订单总额 订单数 支付金额 订单转化率
      平均每单金额 佣金 现金券 成本
    )
  end
end