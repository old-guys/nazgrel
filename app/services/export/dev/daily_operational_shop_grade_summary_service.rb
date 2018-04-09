class Export::Dev::DailyOperationalShopGradeSummaryService
  include Export::BaseService

  def report_fields
    %w(
      id report_date
      total_grade_gold_count
      grade_gold_count
      activation_grade_gold_count
      grade_gold_order_number
      grade_gold_order_amount
      grade_gold_sale_order_amount
      grade_gold_shopkeeper_order_amount
      grade_gold_sale_order_amount_rate
      grade_gold_shopkeeper_order_amount_rate
      total_grade_platinum_count
      grade_platinum_count
      activation_grade_platinum_count
      grade_platinum_order_number
      grade_platinum_order_amount
      grade_platinum_sale_order_amount
      grade_platinum_shopkeeper_order_amount
      grade_platinum_sale_order_amount_rate
      grade_platinum_shopkeeper_order_amount_rate
      total_grade_trainee_count
      grade_trainee_count
      activation_grade_trainee_count
      grade_trainee_order_number
      grade_trainee_order_amount
      grade_trainee_sale_order_amount
      grade_trainee_shopkeeper_order_amount
      grade_trainee_sale_order_amount_rate
      grade_trainee_shopkeeper_order_amount_rate
    )
  end

  def report_head_names
    %w(
      # 报表日期
      累计黄金店主数
      黄金店主数
      活跃黄金店主
      黄金店主订单数
      黄金店主订单金额
      黄金店主销售订单金额
      黄金店主自购订单金额
      黄金店主销售订单占比
      黄金店主自购订单占比
      累计白金店主数
      白金店主数
      活跃白金店主
      白金店主订单数
      白金店主订单金额
      白金店主销售订单金额
      白金店主自购订单金额
      白金店主销售订单占比
      白金店主自购订单占比
      累计体验店主数
      体验店主数
      活跃体验店主
      体验店主订单数
      体验店主订单金额
      体验店主销售订单金额
      体验店主自购订单金额
      体验店主销售订单占比
      体验店主自购订单占比
    )
  end
end