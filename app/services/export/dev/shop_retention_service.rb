class Export::Dev::ShopRetentionService
  include Export::BaseService

  def report_fields
    %w(
      id report_date stat_range
      shopkeeper_count
      activation_shopkeeper_count retention_shopkeeper_count

      activation_shopkeeper_rate retention_shopkeeper_rate
    )
  end

  def report_head_names
    %w(
      # 报表日期 取值范围
      店主数
      下单1次以上 下单2次以上
      店主活跃率 店主留存率
    )
  end

  private
  def report_record_stat_range(record)
    "#{record.start_at.to_date} ~ #{record.end_at.to_date}"
  end
end