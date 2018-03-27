class Export::Dev::ProductRepurchaseService
  include Export::BaseService

  def report_fields
    %w(
      id category stat_range
      online_product_sku_count
      purchase_product_sku_count repurchase_product_sku_count

      activation_product_rate repurchase_product_rate
    )
  end

  def report_head_names
    %w(
      # 产品分类 取值范围
      上架SKU数量
      下单SKU数量 复购SKU数量

      商品活跃率 商品复购率
    )
  end

  private
  def report_record_stat_range(record)
    "#{record.start_at.to_date} ~ #{record.end_at.to_date}"
  end
end